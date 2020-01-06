defmodule TastingsWeb.Live.Components.AddBottle do
  use Phoenix.LiveComponent

	alias Tastings.Events
	alias Tastings.Bottle
	alias TastingsWeb.Router.Helpers, as: Routes

  defp topic(tasting_id), do: "tasting:#{tasting_id}"

  def render(assigns) do
    ~L"""
      <%= unless @has_bottle do %>
        <p>Do you have a bottle to share?</p>
        <button phx-click="has_bottle" phx-value-has-bottle=true>Yes</button>
        <button phx-click="has_bottle" phx-value-has-bottle=false>No, Im a free loader</button>
      <% else %>
        <%= TastingsWeb.LiveEventsView.render("bottle/_new.html", assigns) %>
      <% end %>
    """
  end

  def mount(socket)  do
    {:ok,
      socket
      |> assign(:has_bottle, false)
    }
  end

  def update(assigns, socket) do
    {:ok,
      socket
      |> assign(:changeset, Events.change_bottle(assigns.bottle))
      |> assign(:tasting_id, assigns.tasting_id)
    }
  end

  def handle_event("has_bottle", params, socket) do
    hasBottle = String.to_existing_atom(params["has-bottle"])

    if hasBottle do
      { :noreply, assign(socket, :has_bottle, true) }
    else
      send(socket.root_pid, { :route, "" })
      { :noreply, assign(socket, :has_bottle, false) }
    end
  end

  def handle_event("validate", %{ "bottle" => params }, socket) do
		changeset =
			%Bottle{}
      |> Map.put(:tasting_id, socket.assigns.tasting_id)
			|> Events.change_bottle(params)
			|> Map.put(:action, :insert)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("save", %{ "bottle" => params }, socket) do
    params = Map.put(params, "tasting_id", socket.assigns.tasting_id)

		case Events.create_bottle(params) do
      {:ok, bottle} ->
        socket.assigns.tasting_id
        |> topic
        |> TastingsWeb.Endpoint.broadcast("bottle:added", %{ bottle: bottle })

        send(socket.root_pid, { :route, "" })

        { :noreply, socket }

      {:error, %Ecto.Changeset{} = changeset} ->
        # TODO: do these errors show up correctly?  If there's a general error I might miss it
        # Do a flash?
        # find that documentation about error_tag?
        {:noreply, assign(socket, changeset: changeset)}
		end
  end
end
