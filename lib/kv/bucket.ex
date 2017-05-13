defmodule KV.Bucket do
  @doc """
  Starts a new bucket
  """
  @typedoc "The agent name"
  @type name :: atom | {:global, term} | {:via, module, term}

  @typedoc "The agent reference"
  @type agent :: pid | {atom, node} | name

  # Public API


  @spec start_link :: {atom, pid}
  def start_link do
    Agent.start_link(fn -> %{} end)
  end

  @spec get(agent, String.t) :: number
  def get(bucket, key) do
    Agent.get(bucket, &Map.get(&1, key))
  end

  @spec put(agent, String.t, number) :: :ok
  def put(bucket, key, qty) do
    Agent.update(bucket, &Map.put(&1, key, qty))
  end

  @spec delete(agent, String.t) :: number
  def delete(bucket, key) do
    Agent.get_and_update(bucket, &Map.pop(&1, key))
  end
  # Private API
end