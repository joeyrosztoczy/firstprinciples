defmodule KV.Registry do
  use GenServer

  # Public API
  @doc """
  Starts the registry, accepts a name so that it can be easily supervised
  """
  @spec start_link(atom) :: {:ok, pid}
  def start_link(name) do
    GenServer.start_link(__MODULE__, :ok, name: name)
  end

  @doc """
  Return the PID of a bucket with 'name' in 'server'
  Returns {:ok, pid} if found, :error otherwise
  """
  @spec lookup(atom, String.t) :: {atom, pid}
  def lookup(server, name) do
    GenServer.call(server, {:lookup, name})
  end
  @doc """
  Ensure there is a bucket with 'name' in 'server'
  """
  @spec create_bucket(atom, String.t) :: {atom, pid}
  def create_bucket(server, name) do
    GenServer.call(server, {:create, name})
  end
  # Private API
  def init(:ok) do
    names = %{}
    refs = %{}
    {:ok, {names, refs}}
  end

  def handle_call({:lookup, name}, _from, {names, _} = state) do
    {:reply, Map.fetch(names, name), state}
  end

  def handle_call({:create, name}, _from, {names, refs}) do
    if Map.has_key?(names, name) do
      {:reply, names, {names, refs}}
    else
      # Starts a bucket under a supervisor rather than linking to registry
      {:ok, bucket} = KV.Bucket.Supervisor.start_bucket
      ref = Process.monitor(bucket)
      new_refs = Map.put(refs, ref, name)
      new_names = Map.put(names, name, bucket)
      {:reply, new_names, {new_names, new_refs}}
    end
  end

  def handle_info({:DOWN, ref, :process, _pid, _reason}, {names, refs}) do
    {name, refs} = Map.pop(refs, ref)
    names = Map.delete(names, name)
    {:noreply, {names, refs}}
  end

  def handle_info(_msg, state) do
    {:noreply, state}
  end
end