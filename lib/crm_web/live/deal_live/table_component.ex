defmodule CrmWeb.DealLive.TableComponent do
  use CrmWeb, :live_component

  alias Crm.Deals

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(tab: :index)}
  end

  @impl true
  def handle_event("validate", %{"deal" => deal_params}, socket) do
    changeset =
      socket.assigns.deal
      |> Deals.change_deal(deal_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("change_tab", %{"tab" => tab}, socket) do
    {:noreply, assign(socket, tab: String.to_atom(tab))}
  end

  def is_active_tab(tab, which_tab) do
    if tab == which_tab do
      "is-active"
    else
      ""
    end
  end
end
