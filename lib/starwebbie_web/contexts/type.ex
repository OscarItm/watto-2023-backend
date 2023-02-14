defmodule StarwebbieWeb.Contexts.Type do
  use Absinthe.Schema.Notation
  import AbsintheErrorPayload.Payload

  payload_object(:type_payload, :type)

  object :type do
    field :id, non_null(:id)
    field :name, :string
    field :index_price, :integer
  end

  object :type_mutations do
    @desc "creates a new types"
    field :type_create, :type_payload do
      arg(:name, :string)
      arg(:index_price, :integer)

      # Middleware to run before resolve
      resolve(fn _parent, args, _context ->
        Starwebbie.Items.create_type(args)
      end)

      middleware(&build_payload/2)
    end

    @desc "fetch all types"

    field :type_list, list_of(:type) do
      resolve(fn _parent, _args, _context ->
        {:ok, Starwebbie.Items.list_types()}
      end)
    end

    @desc "fetch one type"

    field :type_by_id, :type do
      arg(:id, :id)

      resolve(fn _parent, %{id: id}, _context ->
        {:ok, Starwebbie.Items.get_type(id)}
      end)
    end

    @desc "updates a type"
    field :type_update, :type_payload do
      arg(:id, :id)
      arg(:name, :string)
      arg(:index_price, :integer)

      type = Starwebbie.Items.get_type(args.id)

      resolve(fn _parent, args, _context ->
        case type do
          nil ->
            {:error, "type not found"}

          type ->
            {:ok, Starwebbie.Items.update_type(type, args)}
        end
      end)

      middleware(&build_payload/2)
    end
  end
end
