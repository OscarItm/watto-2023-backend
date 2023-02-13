defmodule StarwebbieWeb.Contexts.Model do
  use Absinthe.Schema.Notation
  import AbsintheErrorPayload.Payload

  payload_object(:update_model_payload, :model)

  object :model do
    field :name, :string
  end

  object :model_mutations do

    @desc "updates a model"
    field :update_model, :update_model_payload do
      arg(:name, :string)
      arg(:multiplier, :float)
      arg(:id, :integer)

      resolve(&update_model/3)
    end
  end

  defp update_model(_parent, args, _context) do
    {:ok, Starwebbie.Items.update_model(args)}
  end

end
