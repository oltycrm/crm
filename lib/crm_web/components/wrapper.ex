defmodule CrmWeb.Components.Wrapper do
  use Phoenix.Component
  # import CrmWeb.Components.Helpers

  def wrapper(assigns) do
    ~H"""
    <div class="flex-1 flex items-stretch overflow-hidden">
      <!-- Secondary column (hidden on smaller screens) -->
      <aside class="hidden w-96 bg-white border-l border-neutral-200 overflow-y-auto lg:block">
        <div class="h-full w-full bg-blue-100">
          <%= render_slot(@inner_block) %>
        </div>
      </aside>
      <main class="flex-1 overflow-y-auto">
        <!-- Primary column -->
        <section
          aria-labelledby="primary-heading"
          class="min-w-0 flex-1 h-full flex flex-col lg:order-last"
        >
          <%= render_slot(@inner_block) %>
        </section>
      </main>
    </div>
    """
  end
end
