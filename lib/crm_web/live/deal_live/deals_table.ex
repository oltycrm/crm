defmodule CrmWeb.DealLive.DealsTable do
  use CrmWeb, :live_component

  alias Crm.Deals

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(returns: "/")
     |> assign(tab: :index)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("validate", %{"deal" => deal_params}, socket) do
    changeset =
      socket.assigns.deal
      |> Deals.change_deal(deal_params)
      |> Map.put(:action, :validate)

    socket =
      socket
      |> assign(return: "/")

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def get_client_name_by_deal_id(deal_id) do
    deal = Crm.Deals.get_deal!(deal_id)
    client = Crm.Clients.get_client!(deal.client_id)
    client.name
  end

  def get_user_by_deal_id(deal_id) do
    deal = Crm.Deals.get_deal!(deal_id)
    Crm.Accounts.get_user!(deal.user_id)
  end

  def get_product_by_deal_id(deal_id) do
    deal = Crm.Deals.get_deal!(deal_id)
    Crm.Products.get_product!(deal.product_id)
  end

  def render(assigns) do
    ~H"""
    <div class="p-1 mt-5 overflow-auto">
      <div class="overflow-hidden shadow ring-1 ring-black ring-opacity-5 md:rounded-lg ">
        <.table>
          <thead class="bg-white">
            <.tr>
              <.th @click="sortByColumn" scope="col" class="sm:pl-6 pl-4 pr-3">Сделка</.th>
              <.th scope="col" class=" hidden lg:table-cell">Клиент</.th>
              <.th scope="col" class="sm:table-cell hidden">Менеджер</.th>
              <th scope="col" class="relative pyы-3.5 pl-3 pr-4 sm:pr-6">
                <span class="sr-only">Edit</span>
              </th>
            </.tr>
          </thead>
          <tbody class="divide-y divide-neutral-200 bg-white">
            <%= for deal <- @deals do %>
              <.tr>
                <.td class="w-full max-w-0  pr-3 text-sm font-medium text-neutral-900 sm:w-auto sm:max-w-none ">
                  <%= live_redirect  to: Routes.deal_show_path(  @socket  , :show, deal) do %>
                    <div class="flex items-center">
                      <div class="-">
                        <div class="font-medium text-neutral-900"><%= deal.amount %></div>
                        <div class="font-medium text-neutral-900">
                          <%= Crm.Products.get_product!(deal.product_id).name %>
                        </div>
                      </div>
                    </div>

                    <dl class="font-normal lg:hidden">
                      <dd class="mt-1  text-neutral-700 md<:hidden">
                        <%= Crm.Clients.get_client!(deal.client_id).name %>
                      </dd>
                      <dd class="mt-1  text-neutral-900 font-medium sm:hidden">
                        <%= Crm.Accounts.get_user!(deal.user_id).name %>
                      </dd>
                    </dl>
                  <% end %>
                </.td>
                <.td class="hidden px-3 py-4 text-sm text-neutral-500 lg:table-cell">
                  <%= live_redirect  to: Routes.client_show_path(  @socket  , :show, Crm.Clients.get_client!(deal.client_id)), class: "text-blue-500 hover:text-blue-700" do %>
                    <%= Crm.Clients.get_client!(deal.client_id).name %>
                  <% end %>
                </.td>
                <.td class="hidden px-3 py-4 text-sm text-neutral-500 sm:table-cell">
                  <%= Crm.Accounts.get_user!(deal.user_id).name %>
                </.td>

                <td class="whitespace-nowrap py-4 pl-3 pr-4 text-right text-sm font-medium sm:pr-6">
                  <div class="flex flex-col justify-between">
                    <%= link("Удалить",
                      to: "#",
                      phx_click: "delete",
                      phx_value_id: deal.id,
                      data: [confirm: "Are you sure?"],
                      class: "text-red-600 hover:text-red-700"
                    ) %>

                    <%= live_patch("Изменить",
                      to: Routes.deal_index_path(@socket, :edit, deal),
                      class: "text-green-600 hover:text-green-700 mt-2"
                    ) %>
                  </div>
                </td>
              </.tr>
            <% end %>
          </tbody>
        </.table>
      </div>
    </div>
    """
  end

  def rendera(assigns) do
    ~H"""
    <div class="mt-8 flex flex-col">
      <div class="-my-2 -mx-4 overflow-x-auto sm:-mx-6 lg:-mx-8">
        <div class="inline-block min-w-full py-2 align-middle md:px-6 lg:px-8">
          <div class="overflow-hidden shadow ring-1 ring-black ring-opacity-5 md:rounded-lg">
            <table class="min-w-full divide-y divide-neutral-300">
              <thead class="bg-neutral-50">
                <tr>
                  <th
                    scope="col"
                    class="py-3.5 pl-4 pr-3 text-left text-sm font-semibold text-neutral-900 sm:pl-6"
                  >
                    Deal
                  </th>
                  <th scope="col" class="px-3 py-3.5 text-left text-sm font-semibold text-neutral-900">
                    Product
                  </th>

                  <th scope="col" class="px-3 py-3.5 text-left text-sm font-semibold text-neutral-900">
                    Manager
                  </th>
                  <th scope="col" class="relative py-3.5 pl-3 pr-4 sm:pr-6">
                    <span class="sr-only">Edit</span>
                  </th>
                </tr>
              </thead>
              <tbody class="divide-y divide-neutral-200 bg-white">
                <%= for deal <- @deals do %>
                  <tr id={"deal-#{deal.id}"}>
                    <td class="whitespace-nowrap py-4 pl-4 pr-3 text-sm sm:pl-6">
                      <%= live_redirect  to: Routes.deal_show_path(@socket, :show, deal)  do %>
                        <div class="flex items-center">
                          <div class="h-10 w-10 flex-shrink-0">
                            <img
                              class="h-10 w-10 rounded-full"
                              src="https://images.unsplash.com/photo-1517841905240-472988babdf9?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80"
                              alt=""
                            />
                          </div>
                          <div class="ml-4">
                            <div class="font-medium text-neutral-900"><%= deal.amount %></div>
                            <div class="text-neutral-500">
                              <%= get_client_name_by_deal_id(deal.id) %>
                            </div>
                          </div>
                        </div>
                      <% end %>
                    </td>
                    <td class="whitespace-nowrap px-3 py-4 text-sm text-neutral-500">
                      <div class="text-neutral-900"><%= get_product_by_deal_id(deal.id).name %></div>
                    </td>

                    <td class="whitespace-nowrap px-3 py-4 text-sm  text-neutral-900 font-medium">
                      <%= get_user_by_deal_id(deal.id).name %>
                    </td>
                    <td class="relative whitespace-nowrap py-4 pl-3 pr-4 text-right text-sm font-medium sm:pr-6">
                      <%= link("Удалить",
                        to: "#",
                        phx_click: "delete",
                        phx_value_id: deal.id,
                        class: "text-red-600 hover:text-red-900",
                        data: [confirm: "Are you sure?"]
                      ) %>

                      <%= live_redirect("Изменить", to: Routes.deal_index_path(@socket, :edit, deal)) %>
                    </td>
                  </tr>
                <% end %>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
