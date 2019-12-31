defmodule Tastings.TastingLiveView do
	use Phoenix.LiveView

	def render(assigns) do
    TastingsWeb.LiveEventsView.render("show.html", assigns)
  end

  def mount(%{tasting: tasting, current_user: current_user}, socket) do
    {:ok,
     assign(socket,
       tasting: tasting,
       current_user: current_user,
     )}
  end
end
