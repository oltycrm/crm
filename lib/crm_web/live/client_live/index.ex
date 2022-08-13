defmodule CrmWeb.ClientLive.Index do
  use CrmWeb, :live_view

  alias Crm.Clients
  alias Crm.Clients.Client
  alias CrmWeb.Router.Helpers, as: Routes

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Clients.subscribe()

    socket =
      socket
      |> assign(
        page: 1,
        per_page: 10,
        modal: false,
        slide_over: false
      )

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {page, ""} = Integer.parse(params["page"] || "1")
    # {:noreply, socket |> assign(page: page) |> fetch()}

    socket = socket |> assign(page: page) |> fetch()
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp fetch(socket) do
    %{page: page, per_page: per_page} = socket.assigns
    clients = Clients.list_clients(page, per_page)
    socket = assign(socket, clients: clients, page_title: "Страница: #{page}")
    socket
  end

  @impl true
  def handle_info({Clients, [:client | _], _}, socket) do
    {:noreply, fetch(socket)}
  end

  def handle_params(params, _uri, socket) do
    case socket.assigns.live_action do
      :index ->
        {:noreply, assign(socket, modal: false, slide_over: false)}

      :modal ->
        {:noreply, assign(socket, modal: params["size"])}

      :slide_over ->
        {:noreply, assign(socket, slide_over: params["origin"])}

      :pagination ->
        {:noreply, assign(socket, pagination_page: String.to_integer(params["page"]))}
    end
  end

  defp apply_action(socket, :modal, %{"size" => size}) do
    clients = Clients.list_client()

    socket
    |> fetch()
    |> assign(:clients, clients)
    |> assign(:client, %Client{})
  end

  defp apply_action(socket, :edit, %{"client_id" => client_id}) do
    client = Crm.Clients.get_client!(client_id)

    socket
    |> assign(:page_title, "Измениь #{client.name}")
    |> assign(:client, Clients.get_client!(client_id))
  end

  defp apply_action(socket, :new, params) do
    IO.inspect(socket, label: :params_shit)
    # clients = Clients.list_client()

    socket
    |> assign(:page_title, "Новый Клиент")
    |> assign(:client, %Client{})

    # |> assign(:clients, clients)
    # |> fetch()
  end

  defp apply_action(socket, :index, params) do
    {page, ""} = Integer.parse(params["page"] || "1")
    clients = Clients.list_client()

    socket
    |> assign(:page_title, "Страница #{page}")
    |> assign(:client, nil)
    # |> assign(:clients, clients)
    |> assign(page: page)
  end

  @impl true
  def handle_event("delete", %{"id" => client_id}, socket) do
    client = Clients.get_client!(client_id)
    {:ok, _} = Clients.delete_client(client)

    {:noreply, assign(socket, :client_collection, list_client())}
  end

  def handle_event("delete_client", %{"client_id" => client_id}, socket) do
    client = Clients.get_client!(client_id)
    {:ok, _user} = Clients.delete_client(client)

    {:noreply, socket}
  end

  defp list_client do
    Clients.list_client()
  end

  @impl true
  def handle_event("keydown", %{"key" => "ArrowLeft"}, socket) do
    {:noreply, go_page(socket, socket.assigns.page - 1)}
  end

  @impl true
  def handle_event("keydown", %{"key" => "ArrowRight"}, socket) do
    {:noreply, go_page(socket, socket.assigns.page + 1)}
  end

  @impl true
  def handle_event("keydown", _, socket), do: {:noreply, socket}

  defp go_page(socket, page) when page > 0 do
    push_patch(socket, to: Routes.client_index_path(socket, :index, page: page))
  end

  defp go_page(socket, _page), do: socket

  @impl true
  def handle_event("close_modal", _, socket) do
    {:noreply, push_patch(socket, to: "/admin/clients")}
  end

  def handle_event("close_slide_over", _, socket) do
    {:noreply, push_patch(socket, to: "/live/clients")}
  end
end
