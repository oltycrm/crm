# defmodule CrmWeb.DealLive.Lead do
#   use CrmWeb, :live_view

#   alias Crm.Deals
#   alias Crm.Deals.Deal

#   @impl true
#   def mount(_params, _session, socket) do
#     {:ok,
#      socket
#      |> assign(:lead_deals, list_deals_by_status(:lead))
#      |> assign(:work_deals, list_deals_by_status(:work))
#      |> assign(:closed_deals, list_deals_by_status(:closed))
#      |> assign(:deals, list_deals())}
#   end

#   @impl true
#   def handle_params(params, _url, socket) do
#     {:noreply, apply_action(socket, socket.assigns.live_action, params)}
#   end

#   defp apply_action(socket, :index, _params) do
#     socket
#     |> assign(:page_title, "Listing Deals")
#     |> assign(:deals, list_deals())
#   end

#   defp apply_action(socket, :edit, %{"deal_id" => deal_id}) do
#     deal = Deals.get_deal!(deal_id)
#     client = Crm.Clients.get_client!(deal.client_id)

#     socket
#     |> assign(:page_title, "Edit Deal")
#     |> assign(:client, client)
#     |> assign(:deal, deal)
#   end

#   @impl true
#   def handle_event("delete", %{"id" => id}, socket) do
#     deal = Deals.get_deal!(id)
#     {:ok, _} = Deals.delete_deal(deal)

#     {:noreply, assign(socket, :deals, list_deals())}
#   end

#   defp list_deals() do
#     Deals.list_deals()
#   end

#   defp list_deals_by_status(status) do
#     Deals.list_deals_by_status(status)
#   end

#   defp list_new_deals do
#     Deals.list_new_delas()
#   end

#   def render(assigns) do
#     ~H"""
#     <%= if @live_action in [:edit] do %>
#       <.crm_modal max_width="md" title={@page_title}>
#         <div class="gap-5 text-sm">
#           <.live_component
#             module={CrmWeb.ClientLive.FormComponent}
#             id={@client.id || :new}
#             title={@page_title}
#             action={@live_action}
#             client={@client}
#             return_to={Routes.deal_lead_path(@socket, :index)}
#           />
#         </div>
#       </.crm_modal>
#     <% end %>

#     <.h1 label="Leads" />

#     <.tabs underline>
#       <.tab underline number={length(@new_deals)} is_active to="/admin/deals/lead">Home</.tab>
#       <.tab number={63} underline link_type="a" to="/" label="About" />
#       <.tab number={63} underline link_type="a" to="/" label="About" />
#       <.tab number={63} underline link_type="a" to="/" label="About" />
#     </.tabs>
#     <.live_component module={CrmWeb.DealLive.DealsTable} id="hero" deals={@deals} />
#     """
#   end

#   @impl true
#   def handle_event("close_modal", _, socket) do
#     {:noreply, push_patch(socket, to: "/admin/deals/lead")}
#   end

#   def handle_event("close_slide_over", _, socket) do
#     {:noreply, push_patch(socket, to: "/admin/deals/lead")}
#   end
# end
