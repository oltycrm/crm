defmodule CrmWeb.DealLive.FormComponent do
  use CrmWeb, :live_component

  alias Crm.Deals

  @impl true
  def update(%{deal: deal} = assigns, socket) do
    changeset = Deals.change_deal(deal)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"deal" => deal_params}, socket) do
    changeset =
      socket.assigns.deal
      |> Deals.change_deal(deal_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"deal" => deal_params}, socket) do
    save_deal(socket, socket.assigns.action, deal_params)
  end

  defp save_deal(socket, :edit, deal_params) do
    case Deals.update_deal(socket.assigns.deal, deal_params) do
      {:ok, _deal} ->
        {:noreply,
         socket
         |> put_flash(:info, "Deal updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_deal(socket, :new, deal_params) do
    case Deals.create_deal(socket.assigns.client, deal_params) do
      {:ok, _deal} ->
        {:noreply,
         socket
         |> put_flash(:info, "Deal created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp save_deal(socket, :new_deal, deal_params) do
    case Deals.create_deal(socket.assigns.client, deal_params) do
      {:ok, _deal} ->
        {:noreply,
         socket
         |> put_flash(:info, "Deal created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def get_products_list do
    products = Crm.Products.list_products()

    new_products =
      Enum.map(products, fn %Crm.Products.Product{name: name, id: id} -> {name, id} end)

    new_products
    # ["Admin": "admin", "User": "user"]
  end

  def get_users_list do
    users = Crm.Accounts.list_users()
    Enum.map(users, fn %Crm.Accounts.User{name: name, id: id} -> {name, id} end)
  end
end
