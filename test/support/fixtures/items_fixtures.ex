defmodule Starwebbie.ItemsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Starwebbie.Items` context.
  """

  @doc """
  Generate a type.
  """
  def type_fixture(attrs \\ %{}) do
    {:ok, type} =
      attrs
      |> Enum.into(%{
        index_price: 42,
        name: "some name"
      })
      |> Starwebbie.Items.create_type()

    type
  end

  @doc """
  Generate a model.
  """
  def model_fixture(attrs \\ %{}) do
    {:ok, model} =
      attrs
      |> Enum.into(%{
        multiplier: 120.5,
        name: "some name"
      })
      |> Starwebbie.Items.create_model()

    model
  end

  @doc """
  Generate a item.
  """
  def item_fixture(attrs \\ %{}) do
    {:ok, item} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Starwebbie.Items.create_item()

    item
  end
end
