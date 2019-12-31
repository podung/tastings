defmodule TastingsWeb.LiveEventsController do
  use TastingsWeb, :controller

  alias Tastings.Events
  alias Tastings.Events.Tasting
  alias Tastings.TastingLiveView

  def index(conn, _) do
    render(conn, "join.html")
  end

  def join(conn, %{ "username" => username, "join_code" => join_code } ) do
    # TODO:
    #   find user by username
    #   if user doesn't exist, create user by username
    #
    #

    tasting = Tastings.Events.get_by_code(join_code)

    Phoenix.LiveView.Controller.live_render(
            conn,
            TastingLiveView,
            session: %{tasting: tasting, current_user: %{ username: username } }
          )

  end
end
