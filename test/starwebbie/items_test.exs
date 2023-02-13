defmodule Starwebbie.ItemsTest do
  use Starwebbie.DataCase

  alias Starwebbie.Items

  describe "types" do
    alias Starwebbie.Items.Type

    import Starwebbie.ItemsFixtures

    @invalid_attrs %{index_price: nil, name: nil}

    test "list_types/0 returns all types" do
      type = type_fixture()
      assert Items.list_types() == [type]
    end

    test "get_type!/1 returns the type with given id" do
      type = type_fixture()
      assert Items.get_type!(type.id) == type
    end

    test "create_type/1 with valid data creates a type" do
      valid_attrs = %{index_price: 42, name: "some name"}

      assert {:ok, %Type{} = type} = Items.create_type(valid_attrs)
      assert type.index_price == 42
      assert type.name == "some name"
    end

    test "create_type/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Items.create_type(@invalid_attrs)
    end

    test "update_type/2 with valid data updates the type" do
      type = type_fixture()
      update_attrs = %{index_price: 43, name: "some updated name"}

      assert {:ok, %Type{} = type} = Items.update_type(type, update_attrs)
      assert type.index_price == 43
      assert type.name == "some updated name"
    end

    test "update_type/2 with invalid data returns error changeset" do
      type = type_fixture()
      assert {:error, %Ecto.Changeset{}} = Items.update_type(type, @invalid_attrs)
      assert type == Items.get_type!(type.id)
    end

    test "delete_type/1 deletes the type" do
      type = type_fixture()
      assert {:ok, %Type{}} = Items.delete_type(type)
      assert_raise Ecto.NoResultsError, fn -> Items.get_type!(type.id) end
    end

    test "change_type/1 returns a type changeset" do
      type = type_fixture()
      assert %Ecto.Changeset{} = Items.change_type(type)
    end
  end

  describe "models" do
    alias Starwebbie.Items.Model

    import Starwebbie.ItemsFixtures

    @invalid_attrs %{multiplier: nil, name: nil}

    test "list_models/0 returns all models" do
      model = model_fixture()
      assert Items.list_models() == [model]
    end

    test "get_model!/1 returns the model with given id" do
      model = model_fixture()
      assert Items.get_model!(model.id) == model
    end

    test "create_model/1 with valid data creates a model" do
      valid_attrs = %{multiplier: 120.5, name: "some name"}

      assert {:ok, %Model{} = model} = Items.create_model(valid_attrs)
      assert model.multiplier == 120.5
      assert model.name == "some name"
    end

    test "create_model/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Items.create_model(@invalid_attrs)
    end

    test "update_model/2 with valid data updates the model" do
      model = model_fixture()
      update_attrs = %{multiplier: 456.7, name: "some updated name"}

      assert {:ok, %Model{} = model} = Items.update_model(model, update_attrs)
      assert model.multiplier == 456.7
      assert model.name == "some updated name"
    end

    test "update_model/2 with invalid data returns error changeset" do
      model = model_fixture()
      assert {:error, %Ecto.Changeset{}} = Items.update_model(model, @invalid_attrs)
      assert model == Items.get_model!(model.id)
    end

    test "delete_model/1 deletes the model" do
      model = model_fixture()
      assert {:ok, %Model{}} = Items.delete_model(model)
      assert_raise Ecto.NoResultsError, fn -> Items.get_model!(model.id) end
    end

    test "change_model/1 returns a model changeset" do
      model = model_fixture()
      assert %Ecto.Changeset{} = Items.change_model(model)
    end
  end

  describe "items" do
    alias Starwebbie.Items.Item

    import Starwebbie.ItemsFixtures

    @invalid_attrs %{name: nil}

    test "list_items/0 returns all items" do
      item = item_fixture()
      assert Items.list_items() == [item]
    end

    test "get_item!/1 returns the item with given id" do
      item = item_fixture()
      assert Items.get_item!(item.id) == item
    end

    test "create_item/1 with valid data creates a item" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Item{} = item} = Items.create_item(valid_attrs)
      assert item.name == "some name"
    end

    test "create_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Items.create_item(@invalid_attrs)
    end

    test "update_item/2 with valid data updates the item" do
      item = item_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Item{} = item} = Items.update_item(item, update_attrs)
      assert item.name == "some updated name"
    end

    test "update_item/2 with invalid data returns error changeset" do
      item = item_fixture()
      assert {:error, %Ecto.Changeset{}} = Items.update_item(item, @invalid_attrs)
      assert item == Items.get_item!(item.id)
    end

    test "delete_item/1 deletes the item" do
      item = item_fixture()
      assert {:ok, %Item{}} = Items.delete_item(item)
      assert_raise Ecto.NoResultsError, fn -> Items.get_item!(item.id) end
    end

    test "change_item/1 returns a item changeset" do
      item = item_fixture()
      assert %Ecto.Changeset{} = Items.change_item(item)
    end
  end
end
