defmodule CrmWeb.UserLive.PresenceIndex do
  use CrmWeb, :live_view

  alias Crm.Clients
  alias CrmWeb.Presence
  alias Phoenix.Socket.Broadcast

  def mount(%{"name" => name}, _session, socket) do
    if connected?(socket) do
      Crm.Clients.subscribe()
      Phoenix.PubSub.subscribe(Crm.PubSub, "clients")
      Presence.track(self(), "clients", name, %{})
    end

    {:ok, fetch(socket)}
  end

  defp fetch(socket) do
    assign(socket, %{
      clients: Clients.list_clients(1, 10),
      online_clients: CrmWeb.Presence.list("clients"),
      page: 0
    })
  end

  def handle_info(%Broadcast{event: "presence_diff"}, socket) do
    {:noreply, fetch(socket)}
  end

  def handle_info({Clients, [:client | _], _}, socket) do
    {:noreply, fetch(socket)}
  end

  def handle_event("delete_client", client_id, socket) do
    client = Clients.get_client!(client_id)
    {:ok, _user} = Clients.delete_client(client)

    {:noreply, socket}
  end
end
