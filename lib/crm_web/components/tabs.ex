defmodule CrmWeb.Components.Tabs do
  use Phoenix.Component

  alias CrmWeb.Components.Link

  import CrmWeb.Components.Helpers

  # prop class, :string
  # prop underline, :boolean, default: false
  # slot default
  def tabs(assigns) do
    assigns =
      assigns
      |> assign_new(:underline, fn -> false end)
      |> assign_new(:class, fn -> "" end)
      |> assign_rest(~w(underline class)a)

    ~H"""
    <div
      {@rest}
      class={
        build_class(
          [
            "flex gap-x-8 gap-y-2",
            if(@underline, do: "border-b border-neutral-200 dark:border-neutral-600", else: ""),
            @class
          ],
          " "
        )
      }
    >
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  # prop class, :string
  # prop label, :string
  # prop link_type, :string, options: ["a", "live_patch", "live_redirect"]
  # prop number, :integer
  # prop underline, :boolean, default: false
  # prop is_active, :boolean, default: false
  # slot default
  def tab(assigns) do
    assigns =
      assigns
      |> assign_new(:label, fn -> nil end)
      |> assign_new(:class, fn -> "" end)
      |> assign_new(:inner_block, fn -> nil end)
      |> assign_new(:number, fn -> nil end)
      |> assign_new(:link_type, fn -> "a" end)
      |> assign_new(:is_active, fn -> false end)
      |> assign_new(:underline, fn -> false end)
      |> assign_rest(~w(class number link_type is_active underline label)a)

    ~H"""
    <Link.link
      link_type={@link_type}
      label={@label}
      to={@to}
      class={[get_tab_class(@is_active, @underline), @class]}
      {@rest}
    >
      <%= if @number do %>
        <.render_label_or_slot {assigns} />

        <span class={get_tab_number_class(@is_active, @underline)}>
          <%= @number %>
        </span>
      <% else %>
        <.render_label_or_slot {assigns} />
      <% end %>
    </Link.link>
    """
  end

  def render_label_or_slot(assigns) do
    ~H"""
    <%= if @inner_block do %>
      <%= render_slot(@inner_block) %>
    <% else %>
      <%= @label %>
    <% end %>
    """
  end

  # Pill CSS
  defp get_tab_class(is_active, false) do
    base_classes = "whitespace-nowrap px-3 py-2 flex font-medium items-center text-sm rounded-md"

    active_classes =
      if is_active,
        do: "bg-primary-100 dark:bg-neutral-800 text-primary-600 dark:text-primary-500",
        else:
          "text-neutral-500 hover:text-neutral-600 dark:hover:text-neutral-300 dark:text-neutral-400 dark:hover:bg-neutral-800 hover:bg-neutral-100"

    build_class([base_classes, active_classes])
  end

  # Underline CSS
  defp get_tab_class(is_active, underline) do
    base_classes = "whitespace-nowrap flex items-center py-3 px-3 border-b-2 font-medium text-sm"

    active_classes =
      if is_active,
        do: "border-primary-500 text-primary-600 dark:text-primary-500 dark:border-primary-500",
        else:
          "border-transparent text-neutral-500 dark:hover:text-neutral-300 dark:text-neutral-400 hover:border-neutral-300 hover:text-neutral-600"

    underline_classes =
      if is_active && underline,
        do: "",
        else: "hover:border-neutral-300"

    build_class([base_classes, active_classes, underline_classes])
  end

  # Underline
  defp get_tab_number_class(is_active, true) do
    base_classes = "whitespace-nowrap ml-2 py-0.5 px-2 rounded-full text-xs font-normal"

    active_classes =
      if is_active,
        do: "bg-primary-100 text-primary-600",
        else: "bg-neutral-100 text-neutral-500"

    underline_classes =
      if is_active,
        do: "bg-primary-100 dark:bg-primary-600 text-primary-600 dark:text-white",
        else: "bg-neutral-100 dark:bg-neutral-600 dark:text-white text-neutral-500"

    build_class([base_classes, active_classes, underline_classes])
  end

  # Pill
  defp get_tab_number_class(is_active, false) do
    base_classes = "whitespace-nowrap ml-2 py-0.5 px-2 rounded-full text-xs font-normal"

    active_classes =
      if is_active,
        do: "bg-primary-600 text-white",
        else: "bg-neutral-500 dark:bg-neutral-600 text-white"

    build_class([base_classes, active_classes])
  end
end
