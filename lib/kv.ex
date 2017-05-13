defmodule KV do
  use Application
  @moduledoc """
  Documentation for KV.
  """

  @doc """
  Start the supervision tree (registry worker and bucket supervisor)
  on application startup
  """
  def start(_type, _args) do
    KV.Supervisor.start_link
  end
end
