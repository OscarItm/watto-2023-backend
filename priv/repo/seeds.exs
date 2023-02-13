# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Starwebbie.Repo.insert!(%Starwebbie.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Starwebbie.Items
{:ok, model1} = Items.create_model(%{name: "nimbus17", multiplier: :rand.normal()})

{:ok, odel2} = Items.create_model(%{name: "nimbus69", multiplier: :rand.normal()})

{:ok, odel3} = Items.create_model(%{name: "nimbus420", multiplier: :rand.normal()})


{:ok, ype1} = Items.create_type(%{index_price: 1, name: "crystal"})

{:ok, ype2} = Items.create_type(%{index_price: 2, name: "hilt"})

{:ok, ype3} = Items.create_type(%{index_price: 3, name: "etellerandet"})


alias Starwebbie.Users
{:ok, ser1} = Users.create_users(%{username: "watto69", password: "1234", credits: 101})


item1 = Items.create_item(%{name: "wattos item", user_id: ser1.id, type_id: ype1.id, model_id: model1.id})
item1 = Items.create_item(%{name: "wattos item", user_id: ser1.id, type_id: ype2.id, model_id: odel2.id})
item1 = Items.create_item(%{name: "wattos item", user_id: ser1.id, type_id: ype3.id, model_id: odel3.id})

dbg(item1)
