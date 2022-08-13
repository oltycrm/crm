defmodule CrmWeb.Components.SectionHeadings do
  use Phoenix.Component

  import CrmComponents.Link
  import CrmComponents.Typography, only: [h2: 1]

  def section_heading_with_action(assigns) do
    ~H"""
    <div class="pb-5 sm:flex sm:items-center sm:justify-between">
      <.h2><%= @title %></.h2>
      <div class="mt-3 sm:mt-0 sm:ml-4">
        <.section_heading_with_action_button to={@button_link} title={@button_title} />
      </div>
    </div>
    """
  end

  def section_heading_with_action_button(assigns) do
    ~H"""
    <.link
      type="live_patch"
      to={@to}
      class="inline-flex items-center px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500"
    >
      <%= @title %>
    </.link>
    """
  end
end
