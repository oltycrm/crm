defmodule CrmWeb.TransactionLive.FormComponent do
  use CrmWeb, :live_component

  alias Crm.Transactions

  @impl true
  def update(%{transaction: transaction, deal: deal} = assigns, socket) do
    changeset = Transactions.change_transaction(transaction)
    # IO.inspect assigns, label: "assigns_shit"

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"transaction" => transaction_params}, socket) do
    changeset =
      socket.assigns.transaction
      |> Transactions.change_transaction(transaction_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"transaction" => transaction_params}, socket) do
    save_transaction(socket, socket.assigns.action, transaction_params)
  end

  defp save_transaction(socket, :edit, transaction_params) do
    case Transactions.update_transaction(socket.assigns.transaction, transaction_params) do
      {:ok, _transaction} ->
        {:noreply,
         socket
         |> put_flash(:info, "Transaction updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_transaction(socket, :new, transaction_params) do
    # IO.inspect socket.assigns, label: "assigns_shit_create"

    case Transactions.create_transaction(socket.assigns.deal, transaction_params) do
      {:ok, _transaction} ->
        {:noreply,
         socket
         |> put_flash(:info, "Transaction created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def get_card_list do
    # cards = Crm.Cards.list_cards()

    # alive_cards = Crm.Cards.list_cards_by_status("pays")
    alive_cards = Crm.Cards.list_cards_by_statuses(["Платит", "Пополняет", "Привязывается"])

    Enum.map(alive_cards, fn %Crm.Cards.Card{name: name, card_number: card_number, id: id} ->
      {"#{name} #{String.slice(card_number, 14..20)}", id}
    end)
  end
end
