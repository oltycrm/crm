defmodule CrmWeb.LiveHelpers do
  import Phoenix.LiveView
  import Phoenix.LiveView.Helpers

  alias Phoenix.LiveView.JS

  @doc """
  Renders a live component inside a modal.

  The rendered modal receives a `:return_to` option to properly update
  the URL when the modal is closed.

  ## Examples

      <.modal return_to={Routes.client_index_path(@socket, :index)}>
        <.live_component
          module={CrmWeb.ClientLive.FormComponent}
          id={@client.id || :new}
          title={@page_title}
          action={@live_action}
          return_to={Routes.client_index_path(@socket, :index)}
          client: @client
        />
      </.modal>
  """

  def modal(assigns) do
    assigns = assign_new(assigns, :return_to, fn -> nil end)

    ~H"""
    <div
      id="modal"
      phx-remove={hide_modal()}
      class="fixed z-10 inset-0 overflow-y-auto"
      aria-labelledby="modal-title"
      role="dialog"
      aria-modal="true"
    >
      <div class="flex items-end justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:block sm:p-0">
        <div class="fixed inset-0 bg-neutral-500 bg-opacity-75 transition-opacity" aria-hidden="true">
        </div>
        <span class="hidden sm:inline-block sm:align-middle sm:h-screen" aria-hidden="true">
          &#8203;
        </span>
        <div class="relative inline-block align-bottom bg-white rounded-lg px-6 py-6 text-left overflow-hidden shadow-xl transform transition-all sm:align-middle sm:max-w-xl w-full ">
          <div
            id="modal-content"
            phx-click-away={JS.dispatch("click", to: "#close")}
            phx-window-keydown={JS.dispatch("click", to: "#close")}
            phx-key="escape"
          >
            <%= if @return_to do %>
              <%= live_patch("🔥",
                to: @return_to,
                id: "close",
                class: "phx-modal-close",
                phx_click: hide_modal()
              ) %>
            <% else %>
              <a id="close" href="#" class="phx-modal-close" phx-click={hide_modal()}>✖</a>
            <% end %>

            <%= render_slot(@inner_block) %>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def modal(assigns) do
    assigns = assign_new(assigns, :return_to, fn -> nil end)

    ~H"""
    <div id="modal" class="phx-modal fade-in" phx-remove={hide_modal()}>
      <div
        id="modal-content"
        class="phx-modal-content fade-in-scale"
        phx-click-away={JS.dispatch("click", to: "#close")}
        phx-window-keydown={JS.dispatch("click", to: "#close")}
        phx-key="escape"
      >
        <%= if @return_to do %>
          <%= live_patch("✖",
            to: @return_to,
            id: "close",
            class: "phx-modal-close",
            phx_click: hide_modal()
          ) %>
        <% else %>
          <a id="close" href="#" class="phx-modal-close" phx-click={hide_modal()}>✖</a>
        <% end %>

        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end

  defp hide_modal(js \\ %JS{}) do
    js
    |> JS.hide(to: "#modal", transition: "fade-out")
    |> JS.hide(to: "#modal-content", transition: "fade-out-scale")
  end
end
