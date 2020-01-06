defmodule TastingsWeb.TastingLiveView do
  use Phoenix.LiveView
  alias TastingsWeb.Presence
  alias Tastings.Bottle

  alias TastingsWeb.Router.Helpers, as: Routes

  defp topic(tasting_id), do: "tasting:#{tasting_id}"

  # TODO: can I redirect from the render - to change the path?
  def render(assigns) do
    page = case assigns.page do
      :add_bottle -> live_component(assigns.socket,
                       TastingsWeb.Live.Components.AddBottle,
                       id: :add_bottle, bottle: assigns.bottle,
                       tasting_id: assigns.tasting.id)
      :bottle -> live_component(
                   assigns.socket,
                   TastingsWeb.Live.Components.Bottle,
                   id: :bottle,
                   tasting: assigns.tasting,
                   index: assigns.page_params[:index],
                   bottle_count: length(assigns.tasting.bottles))
      _ -> TastingsWeb.LiveEventsView.render("show.html", assigns)
    end

    ~L"""
      <%= page %>
    """
  end

  def mount(%{tasting_id: tasting_id, current_user: current_user} = session, socket) do
    TastingsWeb.Endpoint.subscribe(topic(tasting_id))

    if socket.connected?, do: track_presence(session)

    tasting = tasting_id
              |> Tastings.Events.get_tasting!
              |> Tastings.Events.load_bottles_for_tasting

    {:ok,
      socket
      |> assign(
           current_user: current_user,
           tasting: tasting,
           users: Presence.list_presences(topic(tasting_id)),
           page: :add_bottle,
           bottle: %Bottle{ tasting_id: tasting_id },
           bottle_count: length(tasting.bottles)
      )}
  end

  def handle_info(%{event: "presence_diff"}, socket = %{assigns: %{tasting: tasting}}) do
    {:noreply,
     assign(socket,
       users: Presence.list_presences(topic(tasting.id))
     )}
  end

  def handle_params(%{ "id" => "bottle", "bottle_index" => index } = params, uri, socket) do
    # TODO: figure out why I never end up in here.....

    IO.puts "((((((((((((((((((("
    IO.inspect params
    IO.puts "((((((((((((((((((("

    # TODO: assign bottle and index, but do not redirect
    { :noreply,
      socket
      |> assign(:page, :bottle)
      |> assign(:page_params, %{ index: String.to_integer(index) })
    }
  end

  def handle_params(params, _uri, socket) do
    { :noreply, socket }
  end

  def handle_info({ :route, page = page }, socket) do
    { :noreply,
      socket
      |> navigate(page)
    }
  end

  def handle_info(%{ event: "bottle:added", payload: %{ bottle: bottle } }, socket) do
    tasting = socket.assigns.tasting

    { :noreply,
      socket
      |> assign(:tasting, %{ tasting | bottles: tasting.bottles ++ [bottle] })
    }
  end

  def handle_info(msg, socket) do
    { :noreply, socket }
  end

  defp track_presence(%{ tasting_id: tasting_id, current_user: current_user }) do
    Presence.track_presence(
      self(),
      topic(tasting_id),
      current_user.username, # TODO: change this to user id
      current_user # TODO: just map things I need here
    )
  end

  defp navigate(socket, page, params \\ []) do
    socket
    |> assign(:page, page)
    |> assign(:page_params, params)
    |> live_redirect(to: Routes.live_path(socket, TastingsWeb.TastingLiveView, page, params))
  end
end
