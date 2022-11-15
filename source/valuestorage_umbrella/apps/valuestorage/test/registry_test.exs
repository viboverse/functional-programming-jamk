defmodule ValueStorage.RegistryTest do
    use ExUnit.Case, async: true

    setup context do
        _ = start_supervised!({ValueStorage.Registry, name: context.test})
        %{registry: context.test}
    end

    test "spawn buckets", %{registry: registry} do
        assert ValueStorage.Registry.lookup(registry, "shopping") == :error

        ValueStorage.Registry.create(registry, "shopping")
        assert {:ok, bucket} = ValueStorage.Registry.lookup(registry, "shopping")

        ValueStorage.Bucket.put(bucket, "milk", 1)
        assert ValueStorage.Bucket.get(bucket, "milk") == 1
    end

    test "removes buckets on exit", %{registry: registry} do
        ValueStorage.Registry.create(registry, "shopping")
        {:ok, bucket} = ValueStorage.Registry.lookup(registry, "shopping")
        Agent.stop(bucket)

        _ = ValueStorage.Registry.create(registry, "bogus")
        assert ValueStorage.Registry.lookup(registry, "shopping") == :error
    end

    test "remove bucket on crash", %{registry: registry} do
        ValueStorage.Registry.create(registry, "shopping")
        {:ok, bucket} = ValueStorage.Registry.lookup(registry, "shopping")

        # stop the bucket
        Agent.stop(bucket, :shutdown)
        _ = ValueStorage.Registry.create(registry, "bogus")

        assert ValueStorage.Registry.lookup(registry, "shopping") == :error
    end

end

