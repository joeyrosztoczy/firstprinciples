defmodule KV.Bucket do
  @doc """
  Starts a new bucket
  """

  # Public API
  def start_link do
    Agent.start_link(fn -> %{} end)
  end

  def get(bucket, key) do
    Agent.get(bucket, &Map.get(&1, key))
  end

  def put(bucket, key, qty) do
    Agent.update(bucket, &Map.put(&1, key, qty))
  end

  def delete(bucket, key) do
    Agent.get_and_update(bucket, &Map.pop(&1, key))
  end
  # Private API
end