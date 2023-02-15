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

  payload_object(:me_payload, :user)

  query do
    import_fields(:type_queries)
    import_fields(:model_queries)
    import_fields(:item_queries)

    field :hello, :string do
      arg(:name, :string)

      resolve(fn %{name: name}, _ ->
        {:ok, "Hello #{name}"}
      end)
    end

    field :me, :me_payload do
      arg(:token, non_null(:string))

      resolve(fn _parent, %{token: token}, _context ->
        case StarwebbieWeb.Guardian.decode_and_verify(token) do
          {:ok, claims} ->
            {:ok, claims["sub"]}

          {:error, _} ->
            {:error, "failed to login"}
        end
      end)
    end
  end

  payload_object(:signup_payload, :user_auth)
  payload_object(:signin_payload, :user_auth)

  mutation do
    import_fields(:type_mutations)
    import_fields(:model_mutations)
    import_fields(:item_mutations)

    field :signup, :signup_payload do
      arg(:username, :string)
      arg(:password, :string)

      resolve(fn _parent, %{username: username, password: password}, %{context: ctx} ->
        dbg(ctx)

        case Starwebbie.Users.create_users(%{username: username, password: password}) do
          {:ok, user} ->
            {:ok, token, _claims} = StarwebbieWeb.Guardian.encode_and_sign(user)
            {:ok, %{user: user, token: token}}

          {:error, changeset} ->
            {:error, changeset}
        end
      end)

      middleware(&build_payload/2)
    end

    field :signin, :signin_payload do
      arg(:username, :string)
      arg(:password, :string)

      resolve(fn _parent, %{username: username, password: password}, _context ->
        case Starwebbie.Users.check_auth(username, password) do
          {:ok, user} ->
            {:ok, token, _claims} = StarwebbieWeb.Guardian.encode_and_sign(user)
            {:ok, %{user: user, token: token}}

          {:error, _} ->
            {:error, "failed to login"}
        end
      end)

      middleware(&build_payload/2)
    end
  end
end
