defmodule CrmWeb.SonyAccountLive.Index do
  use CrmWeb, :live_view

  alias Crm.SonyAccounts
  alias Crm.SonyAccounts.SonyAccount
  alias Crm.Clients.Client

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :sony_accounts, list_sony_accounts())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    sony_account = SonyAccounts.get_sony_account!(id)
    client = Crm.Clients.get_client!(sony_account.client_id)

    socket
    |> assign(:page_title, "Edit Sony account")
    |> assign(:sony_account, SonyAccounts.get_sony_account!(id))
    |> assign(:client, client)
  end

  defp apply_action(socket, :upgrade, %{"id" => id}) do
    sony_account = SonyAccounts.get_sony_account!(id)
    client = Crm.Clients.get_client!(sony_account.client_id)

    socket
    |> assign(:page_title, "Edit Sony account")
    |> assign(:sony_account, SonyAccounts.get_sony_account!(id))
    |> assign(:client, client)
  end

  defp apply_action(socket, :new, %{"client_id" => client_id}) do
    client = Crm.Clients.get_client!(client_id)

    socket
    |> assign(:page_title, "New Sony account")
    |> assign(:sony_account, %SonyAccount{})
    |> assign(:client, client)
  end

  # defp apply_action(socket, :delete, params) do
  #   id = 40
  #   sony_account = SonyAccounts.get_sony_account!(id)
  #   {:ok, _} = SonyAccounts.delete_sony_account(sony_account)

  #   {:noreply, assign(socket, :sony_accounts, list_sony_accounts())}
  # end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Sony accounts")
    |> assign(:sony_account, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    sony_account = SonyAccounts.get_sony_account!(id)
    client_id = sony_account.client_id
    {:ok, _} = SonyAccounts.delete_sony_account(sony_account)

    # Crm.SonyAccounts.list_sony_accounts_by_client_id!
    {:noreply,
     assign(socket, :sony_accounts, SonyAccounts.list_sony_accounts_by_client_id!(client_id))}
  end

  defp list_sony_accounts do
    SonyAccounts.list_sony_accounts()
  end
end
