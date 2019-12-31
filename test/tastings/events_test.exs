defmodule Tastings.EventsTest do
  use Tastings.DataCase

  alias Tastings.Events

  describe "tastings" do
    alias Tastings.Events.Tasting

    @valid_attrs %{join_code: "some join_code", name: "some name"}
    @update_attrs %{join_code: "some updated join_code", name: "some updated name"}
    @invalid_attrs %{join_code: nil, name: nil}

    def tasting_fixture(attrs \\ %{}) do
      {:ok, tasting} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Events.create_tasting()

      tasting
    end

    test "list_tastings/0 returns all tastings" do
      tasting = tasting_fixture()
      assert Events.list_tastings() == [tasting]
    end

    test "get_tasting!/1 returns the tasting with given id" do
      tasting = tasting_fixture()
      assert Events.get_tasting!(tasting.id) == tasting
    end

    test "create_tasting/1 with valid data creates a tasting" do
      assert {:ok, %Tasting{} = tasting} = Events.create_tasting(@valid_attrs)
      assert tasting.join_code == "some join_code"
      assert tasting.name == "some name"
    end

    test "create_tasting/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Events.create_tasting(@invalid_attrs)
    end

    test "update_tasting/2 with valid data updates the tasting" do
      tasting = tasting_fixture()
      assert {:ok, %Tasting{} = tasting} = Events.update_tasting(tasting, @update_attrs)
      assert tasting.join_code == "some updated join_code"
      assert tasting.name == "some updated name"
    end

    test "update_tasting/2 with invalid data returns error changeset" do
      tasting = tasting_fixture()
      assert {:error, %Ecto.Changeset{}} = Events.update_tasting(tasting, @invalid_attrs)
      assert tasting == Events.get_tasting!(tasting.id)
    end

    test "delete_tasting/1 deletes the tasting" do
      tasting = tasting_fixture()
      assert {:ok, %Tasting{}} = Events.delete_tasting(tasting)
      assert_raise Ecto.NoResultsError, fn -> Events.get_tasting!(tasting.id) end
    end

    test "change_tasting/1 returns a tasting changeset" do
      tasting = tasting_fixture()
      assert %Ecto.Changeset{} = Events.change_tasting(tasting)
    end
  end
end
