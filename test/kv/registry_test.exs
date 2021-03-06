defmodule KV.RegistryTest do
  use ExUnit.Case, async: true

  setup context do
    {:ok, registry} = KV.Registry.start_link(context.test)
    {:ok, registry: registry}
  end

  test "registers and spawns buckets", %{registry: registry} do
    assert KV.Registry.lookup(registry, "shopping") == :error

    KV.Registry.create_bucket(registry, "shopping")
    assert {:ok, bucket} = KV.Registry.lookup(registry, "shopping")

    KV.Bucket.put(bucket, "milk", 1)
    assert KV.Bucket.get(bucket, "milk") == 1
  end

  test "removes buckets on exit", %{registry: registry} do
    KV.Registry.create_bucket(registry, "stale_entry")
    {:ok, bucket} = KV.Registry.lookup(registry, "stale_entry")
    # Normal stop reason
    Agent.stop(bucket)
    assert KV.Registry.lookup(registry, "stale_entry") == :error
  end

  test "removes bucket on crash", %{registry: registry} do
    KV.Registry.create_bucket(registry, "stale_entry")
    {:ok, bucket} = KV.Registry.lookup(registry, "stale_entry")
    # Abnormal stop reason (crash)
    ref = Process.monitor(bucket)
    Process.exit(bucket, :shutdown)

    # Wait until the bucket is dead
    assert_receive {:DOWN, ^ref, _, _, _}

    assert KV.Registry.lookup(registry, "shopping") == :error
  end
end