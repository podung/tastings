defmodule TastingsWeb.LandingController do
  use TastingsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
