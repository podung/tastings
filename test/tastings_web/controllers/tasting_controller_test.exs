defmodule TastingsWeb.TastingControllerTest do
  use TastingsWeb.ConnCase

  alias Tastings.Events

  @create_attrs %{join_code: "some join_code", name: "some name"}
  @update_attrs %{join_code: "some updated join_code", name: "some updated name"}
  @invalid_attrs %{join_code: nil, name: nil}

  def fixture(:tasting) do
    {:ok, tasting} = Events.create_tasting(@create_attrs)
    tasting
  end

  describe "index" do
    test "lists all tastings", %{conn: conn} do
      conn = get(conn, Routes.tasting_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Tastings"
    end
  end

  describe "new tasting" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.tasting_path(conn, :new))
      assert html_response(conn, 200) =~ "New Tasting"
    end
  end

  describe "create tasting" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.tasting_path(conn, :create), tasting: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.tasting_path(conn, :show, id)

      conn = get(conn, Routes.tasting_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Tasting"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.tasting_path(conn, :create), tasting: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Tasting"
    end
  end

  describe "edit tasting" do
    setup [:create_tasting]

    test "renders form for editing chosen tasting", %{conn: conn, tasting: tasting} do
      conn = get(conn, Routes.tasting_path(conn, :edit, tasting))
      assert html_response(conn, 200) =~ "Edit Tasting"
    end
  end

  describe "update tasting" do
    setup [:create_tasting]

    test "redirects when data is valid", %{conn: conn, tasting: tasting} do
      conn = put(conn, Routes.tasting_path(conn, :update, tasting), tasting: @update_attrs)
      assert redirected_to(conn) == Routes.tasting_path(conn, :show, tasting)

      conn = get(conn, Routes.tasting_path(conn, :show, tasting))
      assert html_response(conn, 200) =~ "some updated join_code"
    end

    test "renders errors when data is invalid", %{conn: conn, tasting: tasting} do
      conn = put(conn, Routes.tasting_path(conn, :update, tasting), tasting: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Tasting"
    end
  end

  describe "delete tasting" do
    setup [:create_tasting]

    test "deletes chosen tasting", %{conn: conn, tasting: tasting} do
      conn = delete(conn, Routes.tasting_path(conn, :delete, tasting))
      assert redirected_to(conn) == Routes.tasting_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.tasting_path(conn, :show, tasting))
      end
    end
  end

  defp create_tasting(_) do
    tasting = fixture(:tasting)
    {:ok, tasting: tasting}
  end
end
