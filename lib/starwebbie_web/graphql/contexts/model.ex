defmodule StarwebbieWeb.Contexts.Model do
  use Absinthe.Schema.Notation
  import AbsintheErrorPayload.Payload

  payload_object(:update_model_payload, :model)
  payload_object(:create_model_payload, :model)
  payload_object(:delete_model_payload, :model)

  object :model_queries do
    @desc "fetches a list of models"
    field :model_list, list_of(non_null(:model)) do
      resolve(fn _parent, _args, _context ->
        {:ok, Starwebbie.Items.list_models()}
      end)
    end

    @desc "fetch a model by id"
    field :model_by_id, :model do
      arg(:id, :integer)

      resolve(fn _parent, %{id: id}, _context ->
        {:ok, Starwebbie.Items.get_model!(id)}
      end)
    end
  end

  object :model_mutations do
    @desc "updates a model"
    field :model_update, :update_model_payload do
      arg(:name, :string)
      arg(:multiplier, :float)
      arg(:id, :integer)

      resolve(&update_model/3)
      middleware(&build_payload/2)
    end

    @desc "create a new model"
    field :model_create, :create_model_payload do
      arg(:name, :string)
      arg(:multiplier, :float)

      resolve(&create_model/3)
      middleware(&build_payload/2)
    end

    @desc "delete a model"
    field :model_delete, :delete_model_payload do
      arg(:id, :integer)

      resolve(&delete_model/3)
      middleware(&build_payload/2)
    end
  end

  defp update_model(_parent, args, _context) do
    Starwebbie.Items.update_model(args)
  end

  defp create_model(_parent, args, _context) do
    Starwebbie.Items.create_model(args)
  end

  defp delete_model(_parent, args, _context) do
    Starwebbie.Items.delete_model(args)
  end
end
