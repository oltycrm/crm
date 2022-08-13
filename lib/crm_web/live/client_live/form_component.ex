defmodule CrmWeb.ClientLive.FormComponent do
  use CrmWeb, :live_component

  alias Crm.Clients

  @impl true
  def update(%{client: client} = assigns, socket) do
    changeset = Clients.change_client(client)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"client" => client_params}, socket) do
    changeset =
      socket.assigns.client
      |> Clients.change_client(client_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"client" => client_params}, socket) do
    save_client(socket, socket.assigns.action, client_params)
  end

  defp save_client(socket, :edit, client_params) do
    case Clients.update_client(socket.assigns.client, client_params) do
      {:ok, _client} ->
        {:noreply,
         socket
         |> put_flash(:success, "Client updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_client(socket, :new, client_params) do
    case Clients.create_client(client_params) do
      {:ok, _client} ->
        {:noreply,
         socket
         |> put_flash(:info, "Client created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
