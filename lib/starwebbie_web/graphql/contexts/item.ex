defmodule StarwebbieWeb.Contexts.Item do
  use Absinthe.Schema.Notation
  import AbsintheErrorPayload.Payload

  payload_object(:update_item_payload, :item)
  payload_object(:create_item_payload, :item)
  payload_object(:delete_item_payload, :item)

  object :item_queries do
    @desc "fetches a list of items"

    field :item_list, list_of(non_null(:item)) do
      middleware(StarwebbieWeb.Authentication)

      resolve(fn _parent, _args, _context ->
        {:ok, Starwebbie.Items.list_items()}
      end)
    end

    @desc "fetch an item by id"
    field :item_by_id, non_null(:item) do
      arg(:id, :integer)
      middleware(StarwebbieWeb.Authentication)

      resolve(fn _parent, %{id: id}, _context ->
        case Starwebbie.Items.get_item(id) do
          nil -> {:error, "Item not found"}
          item -> {:ok, item}
        end
      end)
    end
  end

  object :item_mutations do
    @desc "updates an item"
    field :item_update, :update_item_payload do
      arg(:name, :string)
      arg(:id, :integer)

      resolve(&update_item/3)
      middleware(&build_payload/2)
    end

    @desc "create a new item"
    field :item_create, :create_item_payload do
      arg(:name, non_null(:string))
      arg(:model_id, non_null(:integer))
      arg(:type_id, non_null(:integer))

      middleware(StarwebbieWeb.Authentication)
      resolve(&create_item/3)
      middleware(&build_payload/2)
    end

    @desc "delete an item"
    field :item_delete, :delete_item_payload do
      arg(:id, :integer)

      resolve(&delete_item/3)
      middleware(&build_payload/2)
    end
  end

  defp update_item(_parent, args, _context) do
    Starwebbie.Items.update_item(args)
  end

  defp create_item(_parent, args, _context) do
    Starwebbie.Items.create_item(args)
  end

  defp delete_item(_parent, args, _context) do
    Starwebbie.Items.delete_item(args)
  end
end
