defmodule TastingsWeb.TastingLiveView do
  use Phoenix.LiveView
  alias TastingsWeb.Presence

  defp topic(tasting_id), do: "tasting:#{tasting_id}"

  def render(assigns) do

    unless assigns[:bottle] do
      ~L"""
        <p>Do you have a bottle to share?</p>
        <button phx-click="enter_bottle" phx-value-bottle=true>Yes</button>
        <button phx-click="enter_bottle" phx-value-bottle=false>No, Im a free loader</button>
      """
    else
      TastingsWeb.LiveEventsView.render("show.html", assigns)
    end
  end

  def mount(%{tasting: tasting, current_user: current_user}, socket) do

    if socket.connected? do
      Presence.track_presence(
        self(),
        topic(tasting.id),
        current_user.username, # TODO: change this to user id
        current_user # TODO: just map things I need here
      )
    end

    TastingsWeb.Endpoint.subscribe(topic(tasting.id))

    {:ok,
     assign(socket,
       tasting: tasting,
       current_user: current_user,
       users: Presence.list_presences(topic(tasting.id))
     )}
  end

  def handle_info(%{event: "presence_diff"}, socket = %{assigns: %{tasting: tasting}}) do
    {:noreply,
     assign(socket,
       users: Presence.list_presences(topic(tasting.id))
     )}
  end

	def handle_params(%{ "page": "bottle" }, _uri, socket) do
		#TastingsWeb.LiveEventsView.render("bottle_new.html", assigns)
		{ :noreply, socket }
	end

	def handle_params(params, _uri, socket), do:  {:noreply, socket}

  def handle_event("enter_bottle", params, socket) do

		hasBottle = String.to_existing_atom(params["bottle"])

    if hasBottle do
			IO.puts " got the bottle"
      { :noreply, live_redirect(socket, to: TastingsWeb.Router.Helpers.live_path(socket, TastingsWeb.TastingLiveView, page: "bottle")) }
    else

			IO.puts "IM IN HERE - no bottle"
      { :noreply, assign(socket, :bottle, :skipped) }
    end
  end
end
