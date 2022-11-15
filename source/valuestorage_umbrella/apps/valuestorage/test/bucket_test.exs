defmodule ValueStorage.BucketTest do
    use ExUnit.Case, async: true

    setup do
        bucket = start_supervised!(ValueStorage.Bucket)
        %{bucket: bucket}
    end

    test "stores values by key", %{bucket: bucket} do
        #{:ok, bucket} = ValueStorage.Bucket.start_link([])
        assert ValueStorage.Bucket.get(bucket, "milk") == nil

        ValueStorage.Bucket.put(bucket, "milk", 3)
        assert ValueStorage.Bucket.get(bucket, "milk") == 3
    end

    test "are temporary workers" do
        assert Supervisor.child_spec(ValueStorage.Bucket, []).restart == :temporary
    end
end

