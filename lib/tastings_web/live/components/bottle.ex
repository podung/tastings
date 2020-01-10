defmodule TastingsWeb.Live.Components.Bottle do
  use Phoenix.LiveComponent

  alias TastingsWeb.Router.Helpers, as: Routes
  alias Tastings.Events

  defp topic(tasting_id), do: "tasting:#{tasting_id}"

  def render(assigns) do

    ~L"""
      <h2><%= @bottle.name %></h2>
      <small><%= "(Bottle #{ assigns.index } of #{ assigns.bottle_count })" %></small>

      <%= if assigns.bottle.presented do %>
        <p>This bottle has been presented</p>
      <% else %>
        <p> NOPE </p>
      <% end %>

      <%= if assigns.index > 1, do: live_link("<", to: Routes.live_path(@socket, TastingsWeb.TastingLiveView, :bottle, assigns.index - 1)) %>

      <span>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</span>

      <%= if assigns.index < assigns.bottle_count, do: live_link(">", to: Routes.live_path(@socket, TastingsWeb.TastingLiveView, :bottle, assigns.index + 1)) %>

      <%= if assigns.is_host && assigns.bottle.id != assigns.active_bottle_id do %>
        <div>
          <button phx-click="taste">Start Tasting It!!!!</button>
        </div>
      <% end %>
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
      |> assign(:bottle, Enum.fetch!(assigns.tasting.bottles, assigns.index - 1))
      |> assign(:bottle_count, assigns.bottle_count)
      |> assign(:is_host, assigns.is_host)
      |> assign(:active_bottle_id, assigns.active_bottle_id)
    }
  end

  def handle_event("taste", params, socket) do
    case Events.taste_bottle(socket.assigns.bottle) do
      {:ok, %{ bottle: bottle } } ->
        socket.assigns.tasting.id
        |> topic
        |> TastingsWeb.Endpoint.broadcast("bottle:tasting", %{ bottle: bottle })


        { :noreply, socket }

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.puts "FAILED"
        IO.inspect changeset

        {:noreply, socket}
    end
  end
end
