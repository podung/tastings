defmodule TastingsWeb.Live.Components.Bottle do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
      <%= unless @has_bottle do %>
        <p>Do you have a bottle to share?</p>
        <button phx-click="has_bottle" phx-value-has-bottle=true>Yes</button>
        <button phx-click="has_bottle" phx-value-has-bottle=false>No, Im a free loader</button>
      <% else %>
        <div>I'm going to put a bottle form here</div>
      <% end %>
    """
  end

  def mount(socket)  do
    {:ok,
      assign(socket, :has_bottle, false)}
  end

  # Check these out....
  #def update(assigns, socket) do

  #end

  #def preload(list) do
    ## list of all assigns about to get rendered......
  #end
  #

  def handle_event("has_bottle", params, socket) do
    hasBottle = String.to_existing_atom(params["has-bottle"])

    if hasBottle do
      { :noreply, assign(socket, :has_bottle, true) }
    else
      send(socket.root_pid, { :route, "" })
      { :noreply, assign(socket, :has_bottle, false) }
    end
  end
end
