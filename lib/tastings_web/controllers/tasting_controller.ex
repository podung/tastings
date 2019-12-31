defmodule TastingsWeb.TastingController do
  use TastingsWeb, :controller

  alias Tastings.Events
  alias Tastings.Events.Tasting

  def index(conn, _params) do
    tastings = Events.list_tastings()
    render(conn, "index.html", tastings: tastings)
  end

  def new(conn, _params) do
    changeset = Events.change_tasting(%Tasting{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"tasting" => tasting_params}) do
    case Events.create_tasting(tasting_params) do
      {:ok, tasting} ->
        conn
        |> put_flash(:info, "Tasting created successfully.")
        |> redirect(to: Routes.tasting_path(conn, :show, tasting))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    tasting = Events.get_tasting!(id)
    render(conn, "show.html", tasting: tasting)
  end

  def edit(conn, %{"id" => id}) do
    tasting = Events.get_tasting!(id)
    changeset = Events.change_tasting(tasting)
    render(conn, "edit.html", tasting: tasting, changeset: changeset)
  end

  def update(conn, %{"id" => id, "tasting" => tasting_params}) do
    tasting = Events.get_tasting!(id)

    case Events.update_tasting(tasting, tasting_params) do
      {:ok, tasting} ->
        conn
        |> put_flash(:info, "Tasting updated successfully.")
        |> redirect(to: Routes.tasting_path(conn, :show, tasting))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", tasting: tasting, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    tasting = Events.get_tasting!(id)
    {:ok, _tasting} = Events.delete_tasting(tasting)

    conn
    |> put_flash(:info, "Tasting deleted successfully.")
    |> redirect(to: Routes.tasting_path(conn, :index))
  end
end
