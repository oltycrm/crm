defmodule CrmWeb.ClientLive.Show do
  use CrmWeb, :live_view

  alias Crm.Clients
  alias Phoenix.LiveView.Socket
  alias CrmWeb.Router.Helpers, as: Routes

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  defp apply_action(socket, :new_deal, %{"client_id" => client_id}) do
    client = Crm.Clients.get_client!(client_id)
    changeset = Crm.Deals.change_deal(%Crm.Deals.Deal{})
    client_deals = Crm.Deals.list_deals_by_client_id(client_id)
    sony_accounts = Crm.SonyAccounts.list_sony_accounts_by_client_id!(client_id)

    socket
    |> assign(:page_title, page_title(:new_deal, client))
    |> assign(:deal, %Crm.Deals.Deal{})
    |> assign(:client, client)
    |> assign(:client_deals, client_deals)
    |> assign(:sony_accounts, sony_accounts)
    |> assign(:changeset, changeset)
  end

  defp apply_action(socket, :show, %{"client_id" => client_id}) do
    client = Crm.Clients.get_client!(client_id)
    client_deals = Crm.Deals.list_deals_by_client_id(client_id)
    changeset = Crm.Deals.change_deal(%Crm.Deals.Deal{})
    sony_accounts = Crm.SonyAccounts.list_sony_accounts_by_client_id!(client_id)

    socket
    |> assign(:page_title, "New Deal")
    |> assign(:deal, %Crm.Deals.Deal{})
    |> assign(:client, client)
    |> assign(:changeset, changeset)
    |> assign(:sony_accounts, sony_accounts)
    |> assign(:client_deals, client_deals)
  end

  defp apply_action(socket, :edit, %{"client_id" => client_id}) do
    client = Crm.Clients.get_client!(client_id)
    changeset = Crm.Deals.change_deal(%Crm.Deals.Deal{})
    client_deals = Crm.Deals.list_deals_by_client_id(client_id)
    sony_accounts = Crm.SonyAccounts.list_sony_accounts_by_client_id!(client_id)

    socket
    |> assign(:client_deals, client_deals)
    |> assign(:sony_accounts, sony_accounts)
    |> assign(:page_title, page_title(:edit, client))
    |> assign(:deal, %Crm.Deals.Deal{})
    |> assign(:client, client)
    |> assign(:changeset, changeset)
  end

  @impl true
  def handle_params(params, url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_params(%{"client_id" => client_id}, params, socket) do
    # if connected?(socket), do: Crm.Clients.subscribe(client_id)
    # sony_accounts = Crm.SonyAccounts.list_sony_accounts_by_client_id!(client_id)
    client_deals = Crm.Deals.list_deals_by_client_id(client_id)
    # client = Clients.get_client!(client_id)
    # return_to = Routes.client_show_path(socket, :show, client)

    # {:noreply,
    #  socket
    #  |> assign(:page_title, page_title(socket.assigns.live_action))
    #  |> assign(:client, client)
    #  |> assign(:sony_accounts, sony_accounts)
    #  |> assign(:client_deals, client_deals)    }

    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp page_title(:show), do: "Show Client"
  defp page_title(:edit), do: "Edit Client"
  defp page_title(:edit, client), do: "Изменить #{client.name}"
  defp page_title(:new_deal), do: "New Deal"
  defp page_title(:new_deal, client), do: "Новая Сделка с #{client.name}"

  # def handle_params(%{"id" => id}, _url, socket) do
  #   if connected?(socket), do: Demo.Accounts.subscribe(id)
  #   {:noreply, socket |> assign(id: id) |> fetch()}
  # end

  defp fetch(%Socket{assigns: %{id: id}} = socket) do
    assign(socket, user: Clients.get_client!(id))
    # assign(socket, sony_accounts: SonyAccounts.get_sony_accounts_by_client_id!(id))
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    sony_account = Crm.SonyAccounts.get_sony_account!(id)
    {:ok, _} = Crm.SonyAccounts.delete_sony_account(sony_account)

    {:noreply, assign(socket, :sony_accounts, Crm.SonyAccounts.list_sony_accounts())}
  end

  def get_product_by_deal_id(deal_id) do
    deal = Crm.Deals.get_deal!(deal_id)
    Crm.Products.get_product!(deal.product_id)
  end

  @impl true
  def handle_event("delete_deal", %{"id" => id}, socket) do
    deal = Crm.Deals.get_deal!(id)
    {:ok, _} = Crm.Deals.delete_deal(deal)

    {:noreply, assign(socket, :deals, Crm.Deals.list_deals())}
  end

  @impl true
  def handle_event("close_modal", _, socket) do
    {:noreply, push_patch(socket, to: "/admin/clients/#{socket.assigns.client.id}")}
  end

  def handle_event("close_slide_over", _, socket) do
    {:noreply, push_patch(socket, to: "/live/clients")}
  end
end
