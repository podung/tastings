defmodule TastingsWeb.TastingLiveView do
  use Phoenix.LiveView
  alias TastingsWeb.Presence
  alias Tastings.Bottle

  alias TastingsWeb.Router.Helpers, as: Routes

  defp topic(tasting_id), do: "tasting:#{tasting_id}"

  # TODO: can I redirect from the render - to change the path?
  def render(assigns) do
    page = case assigns.page do
      :bottle -> live_component(assigns.socket,
                  TastingsWeb.Live.Components.Bottle,
                  id: :bottle,
                  bottle: assigns.bottle,
                  tasting_id: assigns.tasting.id)
      _ -> TastingsWeb.LiveEventsView.render("show.html", assigns)
    end

    ~L"""
      <%= page %>
    """
  end

  def mount(%{tasting_id: tasting_id, current_user: current_user} = session, socket) do
    TastingsWeb.Endpoint.subscribe(topic(tasting_id))

    if socket.connected?, do: track_presence(session)

IO.inspect(session)
    {:ok,
      assign(socket,
       current_user: current_user,
       tasting: Tastings.Events.get_tasting!(tasting_id),
       users: Presence.list_presences(topic(tasting_id)),
       page: :bottle,
       bottle: %Bottle{ tasting_id: tasting_id },
       bottles: [] )}
  end

  def handle_info(%{event: "presence_diff"}, socket = %{assigns: %{tasting: tasting}}) do
    {:noreply,
     assign(socket,
       users: Presence.list_presences(topic(tasting.id))
     )}
  end

  def handle_params(%{ "id": "bottle" }, _uri, socket) do
    # TODO: figure out why I never end up in here.....
    IO.puts "AM I IN HERE????"

    { :noreply, assign(socket, :page, :bottle) }
  end

  def handle_params(%{ "id": "foo" }, _uri, socket) do
    IO.puts "FOOOOOOOO - AM I IN HERE????"

    { :noreply, assign(socket, :page, :bottle) }
  end

  def handle_params(params, _uri, socket) do
    # TODO: figure out why I ALWAYS end up in here.....
    # HOW COME I CAN'T INTERCEPT IT? - with the two clauses above?
    IO.puts "What about in this thing???"
    IO.inspect(params)

    {:noreply, socket}
  end

  def handle_info({ :route, page = page }, socket) do
    socket = socket
             |> assign(:page, page)
             |> live_redirect(to: Routes.live_path(socket, TastingsWeb.TastingLiveView, page))

    { :noreply, socket }
  end

  def handle_info(%{ event: "bottle:added", payload: %{ bottle: bottle } }, socket) do
    { :noreply,
      socket
      |> update(:bottles, &(&1 ++ [bottle]))
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
end
