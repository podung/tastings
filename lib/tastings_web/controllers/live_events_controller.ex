defmodule TastingsWeb.LiveEventsController do
  use TastingsWeb, :controller

  alias Tastings.Events
  alias Tastings.Accounts
  alias Tastings.Events.Tasting
  alias Tastings.TastingLiveView

  def index(conn, _) do
    render(conn, "join.html")
  end

  def join(conn, %{ "name" => name, "join_code" => join_code } ) do
    # TODO:
    #   find user by username
    #   if user doesn't exist, create user by username


    user = Accounts.get_user_by_name(name)

    # Yes, there's a race condition here....
    current_user = unless user do
                     { :ok, user } = Accounts.create_user(%{ name: name })
                      IO.puts " IN THIS TIN"
                      IO.inspect user
                     user
                   else
                      IO.puts " IN THAT TIN"
                     user
                   end

    tasting = Events.get_by_code(join_code)

    conn
    |> put_session(:tasting_id, tasting.id)
    |> put_session(:current_user_id, current_user.id)
    |> redirect(to: Routes.live_path(conn, TastingsWeb.TastingLiveView))
  end
end
