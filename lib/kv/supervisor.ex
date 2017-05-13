defmodule KV.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
     # After listing child name, we could specific options like restart value
     # default is permanent (always restarted), others are temporary (never restarted)
     # and transient (only restarted from abnormal kill msg)
    children = [
      worker(KV.Registry, [KV.Registry]),
      supervisor(KV.Bucket.Supervisor, [])
    ]
    # If registry dies, the workers are orphaned
    # rest_for_one strategy kills and restarts
    # processes started after the first child
    supervise(children, strategy: :rest_for_one)
  end
end