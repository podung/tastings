defmodule TastingsWeb.Router do
  use TastingsWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TastingsWeb do
    pipe_through :browser

    get "/", LandingController, :index
    resources "/tastings", TastingController
    get "/join", LiveEventsController, :index
    post "/join", LiveEventsController, :join


    # TODO: get the id into the path somehow
    live "/event/live", TastingLiveView, session: [:tasting_id, :current_user_id]
    live "/event/live/:id", TastingLiveView, session: [:tasting_id, :current_user_id]
    live "/event/live/:id/:bottle_index", TastingLiveView, session: [:tasting_id, :current_user_id]
  end

  # Other scopes may use custom stacks.
  # scope "/api", TastingsWeb do
  #   pipe_through :api
  # end
end
