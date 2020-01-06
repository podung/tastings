defmodule TastingsWeb.Live.Components.Bottle do
  use Phoenix.LiveComponent

  alias TastingsWeb.Router.Helpers, as: Routes

  def render(assigns) do
    #TODO: handle out of bounds condition - fetch! won't blow up for negative (will just loop around)
    adjusted_index = assigns.index - 1;
    bottle = Enum.fetch!(assigns.tasting.bottles, adjusted_index)

    ~L"""
      <h2><%= bottle.name %></h2>
      <small><%= "(Bottle #{ assigns.index } of #{ assigns.bottle_count })" %></small>
      <p>some</p>
      <p>info</p>
      <p>here</p>

      <%= if assigns.index > 1, do: live_link("<", to: Routes.live_path(@socket, TastingsWeb.TastingLiveView, :bottle, assigns.index - 1)) %>
      <%= if assigns.index < assigns.bottle_count, do: live_link(">", to: Routes.live_path(@socket, TastingsWeb.TastingLiveView, :bottle, assigns.index + 1)) %>
    """
  end

  def mount(socket)  do
    {:ok, socket}
  end

  def update(assigns, socket) do
    {:ok,
      socket
      |> assign(:tasting, assigns.tasting)
      |> assign(:index, assigns.index)
      |> assign(:bottle_count, assigns.bottle_count)
    }
  end
end
