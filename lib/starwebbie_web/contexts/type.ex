defmodule StarwebbieWeb.Contexts.Type do
  use Absinthe.Schema.Notation
  import AbsintheErrorPayload.Payload

  payload_object(:update_type_payload, :type)
  payload_object(:create_type_payload, :type)
  payload_object(:delete_type_payload, :type)

  object :type_queries do
    @desc "fetch a list of types"
    field :type_list, list_of(:type) do
      resolve(fn _parent, _args, _context ->
        {:ok, Starwebbie.Items.list_types()}
      end)
    end

    @desc "fetch a type by id"
    field :type_by_id, :type do
      arg(:id, :id)

      resolve(fn _parent, %{id: id}, _context ->
        {:ok, Starwebbie.Items.get_type!(id)}
      end)
    end
  end

  object :type_mutations do
    @desc "updates a type"
    field :type_update, :update_type_payload do
      arg(:id, :integer)
      arg(:name, :string)
      arg(:index_price, :integer)

      resolve(&update_type/3)

      middleware(&build_payload/2)
    end

    @desc "create a new type"
    field :type_create, :create_type_payload do
      arg(:name, :string)
      arg(:index_price, :integer)

      resolve(&create_type/3)

      middleware(&build_payload/2)
    end

    @desc "deletes a type"
    field :type_delete, :delete_type_payload do
      arg(:id, :integer)

      resolve(fn _parent, %{id: id}, _context ->
        Starwebbie.Items.delete_type(id)
      end)

      middleware(&build_payload/2)
    end
  end

  defp update_type(_parent, args, _context) do
    Starwebbie.Items.update_type(args)
  end

  defp create_type(_parent, args, _context) do
    Starwebbie.Items.create_type(args)
  end
end
