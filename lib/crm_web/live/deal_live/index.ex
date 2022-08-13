defmodule CrmWeb.DealLive.Index do
  use CrmWeb, :live_view

  alias Crm.Deals
  alias Crm.Deals.Deal

  require Logger
  # alias CrmWeb.Router.Helpers, as: Routes

  @impl true
  def mount(_params, _session, socket) do
    {
      :ok,
      socket
      |> assign(:closed_deals, list_deals_by_status(:closed))
      |> assign(:work_deals, list_deals_by_status(:work))
      |> assign(:lead_deals, list_deals_by_status(:lead))
      #  |> assign(:deals, list_deals())
    }
  end

  @impl true
  def handle_params(params, url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"deal_id" => deal_id}) do
    deal = Deals.get_deal!(deal_id)
    client = Crm.Clients.get_client!(deal.client_id)

    socket
    |> assign(:page_title, "#{deal.amount} - #{client.name}")
    |> assign(:client, client)
    |> assign(:deal, deal)
  end

  defp apply_action(socket, :new, %{"client_id" => client_id}) do
    client = Crm.Clients.get_client!(client_id)
    changeset = Crm.Deals.change_deal(%Crm.Deals.Deal{})

    socket
    |> assign(:page_title, "New Deal")
    |> assign(:deal, %Deal{})
    |> assign(:client, client)
    |> assign(:changeset, changeset)
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Deals")
    |> assign(:deal, nil)
  end

  defp apply_action(socket, :lead, _params) do
    socket
    |> assign(:page_title, "Listing Deals")
    |> assign(:deal, nil)
  end

  defp apply_action(socket, :work, _params) do
    socket
    |> assign(:page_title, "Listing Deals")
    |> assign(:deal, nil)
  end

  defp apply_action(socket, :closed, _params) do
    socket
    |> assign(:page_title, "Listing Deals")
    |> assign(:deal, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    deal = Deals.get_deal!(id)
    {:ok, _} = Deals.delete_deal(deal)

    {:noreply, assign(socket, :deals, list_deals())}
  end

  defp list_deals() do
    Deals.list_deals()
  end

  defp list_deals_by_status(status) do
    Deals.list_deals_by_status(status)
  end

  defp list_new_deals do
    Deals.list_new_delas()
  end

  @impl true
  def handle_event("close_modal", _, socket) do
    {:noreply, push_patch(socket, to: "/admin/deals/#{socket.assigns.deal.status}")}
  end

  def handle_event("close_slide_over", _, socket) do
    {:noreply, push_patch(socket, to: "/live/deals")}
  end

  def render(%{live_action: :index} = assigns) do
    ~H"""
    <.h2 label="All Deals" />

    <.tabs underline>
      <.tab
        number={length(@lead_deals)}
        type="live_patch"
        underline
        to={Routes.deal_index_path(@socket, :lead)}
        label="Leads"
      />
      <.tab
        number={length(@work_deals)}
        type="live_patch"
        underline
        to={Routes.deal_index_path(@socket, :work)}
        label="В Работе"
      />
      <.tab
        number={length(@closed_deals)}
        type="live_patch"
        underline
        to={Routes.deal_index_path(@socket, :closed)}
        label="Closed"
      />
      <.tab
        number={length(@deals)}
        type="live_patch"
        underline
        to={Routes.deal_index_path(@socket, :index)}
        label="All Leads"
      />
    </.tabs>

    <.live_component
      module={CrmWeb.DealLive.DealsTable}
      id={1..10_000_000 |> Enum.random()}
      deals={@deals}
    />
    """
  end

  def render(%{live_action: :new} = assigns) do
    ~H"""
    <%= if @live_action in [:new] do %>
      <.modal return_to={Routes.client_show_path(@socket, :show, @client)}>
        <.live_component
          module={CrmWeb.DealLive.FormComponent}
          id={@deal.id || :new}
          title={@page_title}
          action={@live_action}
          deal={@deal}
          client={@client}
          return_to={Routes.client_show_path(@socket, :show, @client)}
        />
      </.modal>
    <% end %>
    """
  end

  def render(%{live_action: :edit} = assigns) do
    ~H"""
    <%= if @live_action in [:new, :edit] do %>
      <.crm_modal max_width="md" title={@page_title}>
        <div class="gap-5 text-sm">
          <.live_component
            module={CrmWeb.DealLive.FormComponent}
            id={@deal.id || :new}
            title={@page_title}
            action={@live_action}
            deal={@deal}
            return_to={Routes.deal_index_path(@socket, @deal.status)}
          />
        </div>
      </.crm_modal>
    <% end %>
    """
  end

  def render(%{live_action: :lead} = assigns) do
    ~H"""
    <.h2 label="Лиды" />

    <.tabs underline>
      <.tab
        number={length(@lead_deals)}
        type="live_patch"
        underline
        to={Routes.deal_index_path(@socket, :lead)}
        label="Лиды"
        is_active
      />
      <.tab
        number={length(@work_deals)}
        type="live_patch"
        underline
        to={Routes.deal_index_path(@socket, :work)}
        label="В Работе"
      />
      <.tab
        number={length(@closed_deals)}
        type="live_patch"
        underline
        to={Routes.deal_index_path(@socket, :closed)}
        label="Закрыты"
      />
    </.tabs>

    <.live_component
      module={CrmWeb.DealLive.DealsTable}
      id="hero"
      deals={@lead_deals}
      socket={@socket}
      shit={Routes.deal_index_path(@socket, :closed)}
    />
    """
  end

  def render(%{live_action: :work} = assigns) do
    ~H"""
    <.h2 label="В Работе" />

    <.tabs underline>
      <.tab
        number={length(@lead_deals)}
        type="live_patch"
        underline
        to={Routes.deal_index_path(@socket, :lead)}
        label="Лиды"
      />
      <.tab
        number={length(@work_deals)}
        type="live_patch"
        underline
        to={Routes.deal_index_path(@socket, :work)}
        label="В Работе"
        is_active
      />
      <.tab
        number={length(@closed_deals)}
        type="live_patch"
        underline
        to={Routes.deal_index_path(@socket, :closed)}
        label="Закрыты"
      />
    </.tabs>

    <.live_component module={CrmWeb.DealLive.DealsTable} id="hero" deals={@work_deals} />
    """
  end

  def render(%{live_action: :closed} = assigns) do
    ~H"""
    <.h2 label="Закрыты" />

    <.tabs underline>
      <.tab
        number={length(@lead_deals)}
        type="live_patch"
        underline
        to={Routes.deal_index_path(@socket, :lead)}
        label="Лиды"
      />
      <.tab
        number={length(@work_deals)}
        type="live_patch"
        underline
        to={Routes.deal_index_path(@socket, :work)}
        label="В Работе"
      />
      <.tab
        number={length(@closed_deals)}
        type="live_patch"
        underline
        to={Routes.deal_index_path(@socket, :closed)}
        label="Закрыты"
        is_active
      />
    </.tabs>

    <.live_component module={CrmWeb.DealLive.DealsTable} id="hero" deals={@closed_deals} />
    """
  end

  def rendera(%{live_action: :closed} = assigns) do
    ~H"""
    <.h2 label="Закрыты" />
    <.tabs_nav deals={@closed_deals} socket={@socket} tabs={["a"]} />
    <.live_component module={CrmWeb.DealLive.DealsTable} id="hero" deals={@closed_deals} />
    """
  end

  def tabs_nav(assigns) do
    ~H"""
    <.tabs underline>
      <%= for tab <- @tabs do %>
        <.tab
          number={length(@deals)}
          type="live_patch"
          underline
          to={Routes.deal_index_path(@socket, :lead)}
          label="Лиды"
        />
      <% end %>
    </.tabs>
    """
  end
end
