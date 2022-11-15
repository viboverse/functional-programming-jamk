defmodule ValueStorage.RouterTest do
  use ExUnit.Case

  setup_all do
    current = Application.get_env(:kv, :routing_table)

    Application.put_env(:kv, :routing_table, [
      {?a..?m, :"foo@computer-name"},
      {?n..?z, :"bar@computer-name"}
    ])

    on_exit fn -> Application.put_env(:kv, :routing_table, current) end
  end

  @tag :distributed
  test "route requests across nodes" do
      assert ValueStorage.Router.route("hello", Kernel, :node, []) ==
                :"foo@computer-name"
      assert ValueStorage.Router.route("world", Kernel, :node, []) ==
                :"bar@computer-name"
  end

  test "raises on unknown entries" do
    assert_raise RuntimeError, ~r/could not find entry/, fn ->
      ValueStorage.Router.route(<<0>>, Kernel, :node, [])
    end
  end
  
end
