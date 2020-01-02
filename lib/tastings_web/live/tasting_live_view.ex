defmodule TastingsWeb.TastingLiveView do
	use Phoenix.LiveView

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

    #Presence.track_presence(
      #self(),
      #topic(chat.id),
      #current_user.id,
      #default_user_presence_payload(current_user)
    #)


    {:ok,
     assign(socket,
       tasting: tasting,
       current_user: current_user,
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
