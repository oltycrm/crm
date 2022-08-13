defmodule CrmWeb.PageLive do
  use CrmWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       modal: false,
       slide_over: false,
       pagination_page: 1
     )}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    case socket.assigns.live_action do
      :index ->
        {:noreply, assign(socket, modal: false, slide_over: false)}

      :modal ->
        {:noreply, assign(socket, modal: params["size"])}

      :slide_over ->
        {:noreply, assign(socket, slide_over: params["origin"])}

      :pagination ->
        {:noreply, assign(socket, pagination_page: String.to_integer(params["page"]))}
    end
  end

  def render(assigns) do
    ~H"""
    <div class="h-screen overflow-auto dark:bg-neutral-900">
      <nav class="sticky top-0 flex items-center justify-between w-full h-16 bg-white dark:bg-neutral-900">
        <div class="flex ml-3 sm:ml-10"></div>

        <div class="flex justify-end gap-3 pr-4">
          <.color_scheme_switch />
        </div>
      </nav>
      <.container class="mt-10 mb-32">
        <.link class="underline dark:text-neutral-400" to="/components">Back</.link>
        <.h1 class="mt-5" label="CRM Live View JS Components" />

        <.h2 underline class="mt-10" label="Dropdowns" />
        <.h3 label="" />
        <.dropdown label="Dropdown" js_lib="live_view_js">
          <.dropdown_menu_item type="button">
            <Heroicons.Outline.home class="w-5 h-5 text-neutral-500 dark:text-neutral-300" />
            Button item with icon
          </.dropdown_menu_item>
          <.dropdown_menu_item type="a" href="/" label="a item" />
          <.dropdown_menu_item type="live_patch" href="/" label="Live Patch item" />
          <.dropdown_menu_item type="live_redirect" href="/" label="Live Redirect item" />
        </.dropdown>

        <.h2 underline class="mt-10" label="Modal" />

        <.button label="sm" link_type="live_patch" to={Routes.page_path(@socket, :modal, "sm")} />
        <.button label="md" link_type="live_patch" to={Routes.page_path(@socket, :modal, "md")} />
        <.button label="lg" link_type="live_patch" to={Routes.page_path(@socket, :modal, "lg")} />
        <.button label="xl" link_type="live_patch" to={Routes.page_path(@socket, :modal, "xl")} />
        <.button label="2xl" link_type="live_patch" to={Routes.page_path(@socket, :modal, "2xl")} />
        <.button label="full" link_type="live_patch" to={Routes.page_path(@socket, :modal, "full")} />

        <%= if @modal do %>
          <.crm_modal max_width={@modal} title="Modal">
            <div class="gap-5 text-sm">
              <.form_label label="Add some text here." />
              <div class="flex justify-end">
                <.button label="close" phx-click={CrmComponents.Modal.hide_modal()} />
              </div>
            </div>
          </.crm_modal>
        <% end %>

        <.h2 underline class="mt-10" label="SlideOver" />

        <.button
          label="left"
          link_type="live_patch"
          to={Routes.page_path(@socket, :slide_over, "left")}
        />
        <.button
          label="top"
          link_type="live_patch"
          to={Routes.page_path(@socket, :slide_over, "top")}
        />
        <.button
          label="right"
          link_type="live_patch"
          to={Routes.page_path(@socket, :slide_over, "right")}
        />
        <.button
          label="bottom"
          link_type="live_patch"
          to={Routes.page_path(@socket, :slide_over, "bottom")}
        />

        <%= if @slide_over do %>
          <.slide_over origin={@slide_over} title="SlideOver">
            <div class="gap-5 text-sm">
              <.form_label label="Add some text here." />
              <div class="flex justify-end">
                <.button
                  label="close"
                  phx-click={CrmComponents.SlideOver.hide_slide_over(@slide_over)}
                />
              </div>
            </div>
          </.slide_over>
        <% end %>

        <.h2 underline class="mt-10" label="Interactive Pagination" />
        <.pagination
          link_type="live_patch"
          path="/live/pagination/:page"
          current_page={@pagination_page}
          total_pages={10}
        />

        <.h2 underline class="mt-10" label="Interactive Pagination" />
        <.accordion js_lib="live_view_js">
          <:item heading="Accordion">
            <.p>
              Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam quis. Ut enim ad minim veniam quis. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
            </.p>
          </:item>
          <:item heading="Accordion 2">
            <.p>
              Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam quis. Ut enim ad minim veniam quis. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
            </.p>
          </:item>
          <:item heading="Accordion 3">
            <.p>
              Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam quis. Ut enim ad minim veniam quis. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
            </.p>
          </:item>
        </.accordion>
      </.container>
    </div>
    """
  end

  @impl true
  def handle_event("close_modal", _, socket) do
    {:noreply, push_patch(socket, to: "/live")}
  end

  def handle_event("close_slide_over", _, socket) do
    {:noreply, push_patch(socket, to: "/live")}
  end
end
