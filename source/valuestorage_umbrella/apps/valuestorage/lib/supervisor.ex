defmodule ValueStorage.Supervisor do
    use Supervisor

    def start_link(opts) do
        Supervisor.start_link(__MODULE__, :ok, opts)
    end

    @impl true
    def init(:ok) do
        children = [
            {DynamicSupervisor, name: ValueStorage.BucketSupervisor, strategy: :one_for_one},
            {ValueStorage.Registry, name: ValueStorage.Registry},
            {Task.Supervisor, name: ValueStorage.RouterTasks}
        ]

        Supervisor.init(children, strategy: :one_for_one)
    end
end

