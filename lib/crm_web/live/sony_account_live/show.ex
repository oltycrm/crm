defmodule CrmWeb.SonyAccountLive.Show do
  use CrmWeb, :live_view

  alias Crm.SonyAccounts

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:sony_account, SonyAccounts.get_sony_account!(id))}
  end

  defp page_title(:show), do: "Show Sony account"
  defp page_title(:edit), do: "Edit Sony account"
end
