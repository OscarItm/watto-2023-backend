defmodule StarwebbieWeb.Schema do
  use Absinthe.Schema
  import AbsintheErrorPayload.Payload
  alias Starwebbie.{Items, Users}
  import_types(StarwebbieWeb.Models)

  import_types(StarwebbieWeb.Contexts.Type)
  import_types(Absinthe.Type.Custom)
  import_types(AbsintheErrorPayload.ValidationMessageTypes)
  import_types(StarwebbieWeb.Contexts.Type)
  import_types(Absinthe.Type.Custom)
  import_types(AbsintheErrorPayload.ValidationMessageTypes)
  import_types(StarwebbieWeb.Contexts.Model)
  import_types(StarwebbieWeb.Contexts.Item)
  import_types(StarwebbieWeb.Contexts.User)

  query do
    import_fields(:type_queries)
    import_fields(:model_queries)
    import_fields(:item_queries)
    import_fields(:user_queries)
  end

  mutation do
    import_fields(:type_mutations)
    import_fields(:model_mutations)
    import_fields(:item_mutations)
    import_fields(:user_mutations)
  end

  @impl true
  def context(ctx) do
    loader =
      Dataloader.new()
      |> Dataloader.add_source(Users, Starwebbie.Users.data())
      |> Dataloader.add_source(Items, Starwebbie.Items.data())

    Map.put(ctx, :loader, loader)
  end

  @impl true
  def plugins do
    [
      Absinthe.Middleware.Dataloader
    ] ++ Absinthe.Plugin.defaults()
  end
end
