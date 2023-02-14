defmodule StarwebbieWeb.Authentication do
  @behaviour Absinthe.Middleware

  @impl true
  def call(resolution, _config) do
    case resolution.context do
      %{current_user: _} ->
        resolution

      _ ->
        resolution
        |> Absinthe.Resolution.put_result({:error, "Not authenticated"})
    end
  end
end
