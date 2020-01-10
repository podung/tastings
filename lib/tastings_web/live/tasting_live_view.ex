defmodule TastingsWeb.TastingLiveView do
  use Phoenix.LiveView
  alias TastingsWeb.Presence
  alias Tastings.Bottle
  alias Tastings.Accounts

  alias TastingsWeb.Router.Helpers, as: Routes

  defp topic(tasting_id), do: "tasting:#{tasting_id}"

  # TODO: can I redirect from the render - to change the path?
  def render(assigns) do
        IO.inspect assigns.current_user.name
        IO.puts "The value out here: #{assigns.current_user.name == "Joe"}"

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
                   bottle_count: length(assigns.tasting.bottles),
                   is_host: assigns.current_user.name == "Joe",
                   active_bottle_id: assigns.tasting.active_bottle_id)


      _ -> TastingsWeb.LiveEventsView.render("show.html", assigns)
    end

    ~L"""
      <%= page %>
    """
  end

  def mount(%{tasting_id: tasting_id, current_user_id: current_user_id} = session, socket) do
    TastingsWeb.Endpoint.subscribe(topic(tasting_id))

    tasting = tasting_id
              |> Tastings.Events.get_tasting!
              |> Tastings.Events.load_bottles_for_tasting

    user = Accounts.get_user!(current_user_id)

    if socket.connected?, do: track_presence(tasting_id, user)

    {:ok,
      socket
      |> assign(
           current_user: user,
           tasting: tasting,
           users: Presence.list_presences(topic(tasting_id)),
           page: :add_bottle,
           bottle: %Bottle{ tasting_id: tasting_id },
           bottle_count: length(tasting.bottles),
      )}
  end

  def handle_info(%{event: "presence_diff"}, socket = %{assigns: %{tasting: tasting}}) do
    {:noreply,
     assign(socket,
       users: Presence.list_presences(topic(tasting.id))
     )}
  end

  def handle_params(%{ "id" => "bottle", "bottle_index" => index } = params, uri, socket) do
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

  def handle_info(%{ event: "bottle:tasting", payload: %{ bottle: bottle } }, socket) do
    tasting = socket.assigns.tasting

    # TODO: find the bottle that is being tasted, and mark presented as true
    tasting.bottles
    index = Enum.find_index(tasting.bottles, fn b -> b.id == bottle.id end)

    tasting = %{ tasting |
      bottles: List.update_at(tasting.bottles, index, fn b -> %{ b | presented: true } end),
      active_bottle_id: bottle.id
    }

    { :noreply,
      socket
      |> assign(:tasting, tasting)
      |> assign(:active_bottle_id, bottle.id)
    }
  end

  def handle_info(msg, socket) do
    { :noreply, socket }
  end

  defp track_presence(tasting_id, current_user) do
    Presence.track_presence(
      self(),
      topic(tasting_id),
      current_user.id, # TODO: change this to user id
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
