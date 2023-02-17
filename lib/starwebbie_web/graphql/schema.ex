defmodule StarwebbieWeb.Schema do
  use Absinthe.Schema
  import AbsintheErrorPayload.Payload

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

    field :hello, :string do
      arg(:name, :string)

      resolve(fn %{name: name}, _ ->
        {:ok, "Hello #{name}"}
      end)
    end
  end

  mutation do
    import_fields(:type_mutations)
    import_fields(:model_mutations)
    import_fields(:item_mutations)
    import_fields(:user_mutations)
  end
end
