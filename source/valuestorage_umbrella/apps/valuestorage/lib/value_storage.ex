defmodule ValueStorage do
  use Application

  @impl true
  def start(_type, _args) do
    ValueStorage.Supervisor.start_link(name: ValueStorage.Supervisor)
  end
end

