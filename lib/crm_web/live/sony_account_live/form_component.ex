defmodule CrmWeb.SonyAccountLive.FormComponent do
  use CrmWeb, :live_component
  alias Crm.SonyAccounts

  @impl true
  def update(%{sony_account: sony_account} = assigns, socket) do
    changeset = SonyAccounts.change_sony_account(sony_account)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"sony_account" => sony_account_params}, socket) do
    changeset =
      socket.assigns.sony_account
      |> SonyAccounts.change_sony_account(sony_account_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"sony_account" => sony_account_params}, socket) do
    save_sony_account(socket, socket.assigns.action, sony_account_params)
  end

  defp save_sony_account(socket, :edit, sony_account_params) do
    case SonyAccounts.update_sony_account(
           socket.assigns.client,
           socket.assigns.sony_account,
           sony_account_params
         ) do
      {:ok, _sony_account} ->
        {:noreply,
         socket
         |> put_flash(:info, "Sony account updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_sony_account(socket, :new, sony_account_params) do
    case SonyAccounts.create_sony_account(socket.assigns.client, sony_account_params) do
      {:ok, _sony_account} ->
        {:noreply,
         socket
         |> put_flash(:info, "Sony account created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
