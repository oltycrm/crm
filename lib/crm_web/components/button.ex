defmodule CrmWeb.Components.Button do
  use Phoenix.Component

  alias CrmWeb.Components.Loading
  alias CrmWeb.Components.Heroicons
  alias CrmWeb.Components.Link

  import CrmWeb.Components.Helpers

  # prop class, :string
  # prop color, :string, options: ["primary", "secondary", "info", "success", "warning", "danger", "neutral"]
  # prop link_type, :string, options: ["button", "a", "live_patch", "live_redirect"]
  # prop label, :string
  # prop size, :string
  # prop variant, :string
  # prop to, :string
  # prop loading, :boolean, default: false
  # prop disabled, :boolean, default: false
  # slot default
  def button(assigns) do
    assigns =
      assigns
      |> assign_new(:link_type, fn -> "button" end)
      |> assign_new(:inner_block, fn -> nil end)
      |> assign_new(:loading, fn -> false end)
      |> assign_new(:size, fn -> "md" end)
      |> assign_new(:disabled, fn -> false end)
      |> assign_new(:rest, fn -> get_rest(assigns) end)
      |> assign_new(:classes, fn -> button_classes(assigns) end)
      |> assign_new(:class, fn -> "" end)
      |> assign_new(:to, fn -> nil end)

    ~H"""
    <Link.link to={@to} link_type={@link_type} class={@classes} disabled={@disabled} {@rest}>
      <%= if @loading do %>
        <Loading.spinner show={true} size_class={get_spinner_size_classes(@size)} />
      <% end %>

      <%= if @inner_block do %>
        <%= render_slot(@inner_block) %>
      <% else %>
        <%= @label %>
      <% end %>
    </Link.link>
    """
  end

  # prop class, :string
  # prop color, :string, options: ["primary", "secondary", "info", "success", "warning", "danger", "neutral"]
  # prop link_type, :string, options: ["button", "a", "live_patch", "live_redirect"]
  # prop label, :string
  # prop size, :string
  # prop variant, :string
  # prop to, :string
  # prop loading, :boolean, default: false
  # prop disabled, :boolean, default: false
  # slot default
  def icon_button(assigns) do
    assigns =
      assigns
      |> assign_new(:link_type, fn -> "button" end)
      |> assign_new(:inner_block, fn -> nil end)
      |> assign_new(:loading, fn -> false end)
      |> assign_new(:size, fn -> "sm" end)
      |> assign_new(:disabled, fn -> false end)
      |> assign_new(:rest, fn -> get_rest(assigns) end)
      |> assign_new(:class, fn -> "" end)
      |> assign_new(:to, fn -> nil end)
      |> assign_new(:color, fn -> "neutral" end)

    ~H"""
    <Link.link
      to={@to}
      link_type={@link_type}
      class={
        build_class([
          "rounded-full p-2 inline-block",
          get_disabled_classes(@disabled),
          get_icon_button_background_color_classes(@color),
          get_icon_button_color_classes(@color),
          @class
        ])
      }
      disabled={@disabled}
      {@rest}
    >
      <%= if @loading do %>
        <Loading.spinner show={true} size_class={get_spinner_size_classes(@size)} />
      <% else %>
        <Heroicons.Solid.render
          icon={@icon}
          class={
            build_class([
              get_icon_button_size_classes(@size)
            ])
          }
        />
      <% end %>
    </Link.link>
    """
  end

  defp button_classes(opts) do
    opts = %{
      size: opts[:size] || "md",
      variant: opts[:variant] || "solid",
      color: opts[:color] || "primary",
      loading: opts[:loading] || false,
      disabled: opts[:disabled] || false,
      icon: opts[:icon] || false,
      user_added_classes: opts[:class] || ""
    }

    color_css = get_color_classes(opts)

    size_css =
      case opts[:size] do
        "xs" -> "text-xs leading-4 px-2.5 py-1.5"
        "sm" -> "text-sm leading-4 px-3 py-2"
        "md" -> "text-sm leading-5 px-4 py-2"
        "lg" -> "text-base leading-6 px-4 py-2"
        "xl" -> "text-base leading-6 px-6 py-3"
      end

    loading_css =
      if opts[:loading] do
        "flex gap-2 items-center whitespace-nowrap disabled cursor-not-allowed"
      else
        ""
      end

    icon_css =
      if opts[:icon] do
        "flex gap-2 items-center whitespace-nowrap"
      else
        ""
      end

    [
      opts.user_added_classes,
      color_css,
      size_css,
      loading_css,
      get_disabled_classes(opts[:disabled]),
      icon_css,
      "font-medium rounded-md inline-flex items-center justify-center border focus:outline-none transition duration-150 ease-in-out"
    ]
    |> build_class()
  end

  defp get_rest(assigns) do
    assigns_to_attributes(assigns, [
      :loading,
      :disabled,
      :link_type,
      :size,
      :variant,
      :color,
      :icon,
      :class,
      :to
    ])
  end

  defp get_color_classes(%{color: "primary", variant: variant}) do
    case variant do
      "outline" ->
        "border-primary-400 dark:border-primary-400 dark:hover:border-primary-300 dark:hover:text-primary-300 dark:hover:bg-transparent dark:text-primary-400 hover:border-primary-600 text-primary-600 hover:text-primary-700 active:bg-primary-200 hover:bg-primary-50 focus:border-primary-700 focus:shadow-outline-primary"

      "inverted" ->
        "border-primary-400 dark:border-primary-400 dark:hover:border-primary-700 dark:hover:text-white dark:hover:bg-primary-700 dark:text-primary-400 hover:border-primary-600 text-primary-600 hover:text-white active:bg-primary-700 hover:bg-primary-600 focus:border-primary-700 focus:shadow-outline-primary"

      "shadow" ->
        "shadow-xl border-transparent text-white bg-primary-600 active:bg-primary-700 hover:bg-primary-700 focus:bg-primary-700 active:bg-primary-800 focus:shadow-outline-primary shadow-primary-500/30 dark:hover:shadow-primary-600/30 dark:focus:shadow-primary-600/30 dark:active:shadow-primary-700/30"

      _ ->
        "border-transparent text-white bg-primary-600 active:bg-primary-700 hover:bg-primary-700 focus:bg-primary-700 active:bg-primary-800 focus:shadow-outline-primary"
    end
  end

  defp get_color_classes(%{color: "secondary", variant: variant}) do
    case variant do
      "outline" ->
        "border-secondary-400 dark:border-secondary-400 dark:hover:border-secondary-300 dark:hover:text-secondary-300 dark:hover:bg-transparent dark:text-secondary-400 hover:border-secondary-600 text-secondary-600 hover:text-secondary-700 active:bg-secondary-200 hover:bg-secondary-50 focus:border-secondary-700 focus:shadow-outline-secondary"

      "inverted" ->
        "border-secondary-400 dark:border-secondary-400 dark:hover:border-secondary-700 dark:hover:text-white dark:hover:bg-secondary-700 dark:text-secondary-400 hover:border-secondary-600 text-secondary-600 hover:text-white active:bg-secondary-700 hover:bg-secondary-600 focus:border-secondary-700 focus:shadow-outline-secondary"

      "shadow" ->
        "shadow-xl border-transparent text-white bg-secondary-600 active:bg-secondary-700 hover:bg-secondary-700 focus:bg-secondary-700 active:bg-secondary-800 focus:shadow-outline-secondary shadow-secondary-500/30 dark:hover:shadow-secondary-600/30 dark:focus:shadow-secondary-600/30 dark:active:shadow-secondary-700/30"

      _ ->
        "border-transparent text-white bg-secondary-600 active:bg-secondary-700 hover:bg-secondary-700 focus:bg-secondary-700 active:bg-secondary-800 focus:shadow-outline-secondary"
    end
  end

  defp get_color_classes(%{color: "white", variant: variant}) do
    case variant do
      "outline" ->
        "border-neutral-400 dark:border-neutral-300 dark:hover:border-neutral-200 dark:hover:text-neutral-200 dark:hover:bg-transparent dark:text-neutral-300 hover:border-neutral-600 text-neutral-600 hover:text-neutral-700 active:bg-neutral-100 hover:bg-neutral-50 focus:bg-neutral-50 focus:border-neutral-500 active:border-neutral-600"

      "inverted" ->
        "border-neutral-400 dark:border-white dark:hover:border-neutral-700 dark:hover:text-black dark:hover:bg-white dark:text-neutral-300 hover:border-neutral-600 text-neutral-600 hover:text-black active:bg-neutral-700 hover:bg-white focus:border-neutral-700 focus:shadow-outline-neutral"

      "shadow" ->
        "shadow-xl text-neutral-700 bg-white border-neutral-300 hover:text-neutral-900 hover:text-neutral-900 hover:border-neutral-400 hover:bg-neutral-50 focus:outline-none focus:border-neutral-400 focus:bg-neutral-100 focus:text-neutral-900 active:border-neutral-400 active:bg-neutral-200 dark:bg-white dark:hover:bg-neutral-200 dark:hover:border-transparent dark:border-transparent active:text-black shadow-neutral-500/30 dark:shadow-neutral-200/30 dark:hover:shadow-neutral-300/30 dark:focus:shadow-neutral-300/30 dark:active:shadow-neutral-400/30"

      _ ->
        "text-neutral-700 bg-white border-neutral-300 hover:text-neutral-900 hover:text-neutral-900 hover:border-neutral-400 hover:bg-neutral-50 focus:outline-none focus:border-neutral-400 focus:bg-neutral-100 focus:text-neutral-900 active:border-neutral-400 active:bg-neutral-200 active:text-black dark:bg-white dark:hover:bg-neutral-200 dark:hover:border-transparent dark:border-transparent"
    end
  end

  defp get_color_classes(%{color: "pure_white", variant: variant}) do
    case variant do
      _ ->
        "text-neutral-700 bg-white border-transparent border-white hover:text-neutral-900 hover:text-neutral-900 hover:border-transparent hover:bg-neutral-50 focus:outline-none focus:border-transparent focus:bg-neutral-100 focus:text-neutral-900 active:border-transparent active:bg-neutral-200 active:text-black dark:bg-white dark:hover:bg-neutral-200 dark:hover:border-transparent dark:border-transparent"
    end
  end

  defp get_color_classes(%{color: "info", variant: variant}) do
    case variant do
      "outline" ->
        "border-blue-400 dark:border-blue-400 dark:hover:border-blue-300 dark:hover:text-blue-300 dark:hover:bg-transparent dark:text-blue-400 hover:border-blue-600 text-blue-600 hover:text-blue-700 active:border-blue-600 focus:text-blue-600 active:text-blue-700 active:bg-blue-100 hover:bg-blue-50 focus:border-blue-700"

      "inverted" ->
        "border-blue-400 dark:border-blue-400 dark:hover:border-blue-700 dark:hover:text-white dark:hover:bg-blue-700 dark:text-blue-400 hover:border-blue-600 text-blue-600 hover:text-white active:bg-blue-700 hover:bg-blue-600 focus:border-blue-700 focus:shadow-outline-blue"

      "shadow" ->
        "shadow-xl border-transparent text-white bg-blue-600 active:bg-blue-700 hover:bg-blue-700 focus:bg-blue-700 active:bg-blue-800 focus:shadow-outline-blue shadow-blue-500/30 dark:hover:shadow-blue-600/30 dark:focus:shadow-blue-600/30 dark:active:shadow-blue-700/30"

      _ ->
        "border-transparent text-white bg-blue-600 active:bg-blue-700 hover:bg-blue-700 active:bg-blue-700 focus:bg-blue-700"
    end
  end

  defp get_color_classes(%{color: "success", variant: variant}) do
    case variant do
      "outline" ->
        "border-green-400 dark:border-green-400 dark:hover:border-green-300 dark:hover:text-green-300 dark:hover:bg-transparent dark:text-green-400 hover:border-green-600 text-green-600 hover:text-green-700 active:border-green-600 focus:text-green-600 active:text-green-700 active:bg-green-100 hover:bg-green-50 focus:border-green-700"

      "inverted" ->
        "border-green-400 dark:border-green-400 dark:hover:border-green-700 dark:hover:text-white dark:hover:bg-green-700 dark:text-green-400 hover:border-green-600 text-green-600 hover:text-white active:bg-green-700 hover:bg-green-600 focus:border-green-700 focus:shadow-outline-green"

      "shadow" ->
        "shadow-xl border-transparent text-white bg-green-600 active:bg-green-700 hover:bg-green-700 focus:bg-green-700 active:bg-green-800 focus:shadow-outline-green shadow-green-500/30 dark:hover:shadow-green-600/30 dark:focus:shadow-green-600/30 dark:active:shadow-green-700/30"

      _ ->
        "border-transparent text-white bg-green-600 active:bg-green-700 hover:bg-green-700 active:bg-green-700 focus:bg-green-700"
    end
  end

  defp get_color_classes(%{color: "warning", variant: variant}) do
    case variant do
      "outline" ->
        "border-yellow-400 dark:border-yellow-400 dark:hover:border-yellow-300 dark:hover:text-yellow-300 dark:hover:bg-transparent dark:text-yellow-400 hover:border-yellow-600 text-yellow-600 hover:text-yellow-700 active:border-yellow-600 focus:text-yellow-600 active:text-yellow-700 active:bg-yellow-100 hover:bg-yellow-50 focus:border-yellow-700"

      "inverted" ->
        "border-yellow-400 dark:border-yellow-400 dark:hover:border-yellow-700 dark:hover:text-white dark:hover:bg-yellow-700 dark:text-yellow-400 hover:border-yellow-600 text-yellow-600 hover:text-white active:bg-yellow-700 hover:bg-yellow-600 focus:border-yellow-700 focus:shadow-outline-yellow"

      "shadow" ->
        "shadow-xl border-transparent text-white bg-yellow-600 active:bg-yellow-700 hover:bg-yellow-700 focus:bg-yellow-700 active:bg-yellow-800 focus:shadow-outline-yellow shadow-yellow-500/30 dark:hover:shadow-yellow-600/30 dark:focus:shadow-yellow-600/30 dark:active:shadow-yellow-700/30"

      _ ->
        "border-transparent text-white bg-yellow-600 active:bg-yellow-700 hover:bg-yellow-700 active:bg-yellow-700 focus:bg-yellow-700"
    end
  end

  defp get_color_classes(%{color: "danger", variant: variant}) do
    case variant do
      "outline" ->
        "border-red-400 dark:border-red-400 dark:hover:border-red-300 dark:hover:text-red-300 dark:hover:bg-transparent dark:text-red-400 hover:border-red-600 text-red-600 hover:text-red-700 active:bg-red-200 active:border-red-700 hover:bg-red-50 focus:border-red-700"

      "inverted" ->
        "border-red-400 dark:border-red-400 dark:hover:border-red-700 dark:hover:text-white dark:hover:bg-red-700 dark:text-red-400 hover:border-red-600 text-red-600 hover:text-white active:bg-red-700 hover:bg-red-600 focus:border-red-700 focus:shadow-outline-red"

      "shadow" ->
        "shadow-xl border-transparent text-white bg-red-600 active:bg-red-700 hover:bg-red-700 focus:bg-red-700 active:bg-red-800 focus:shadow-outline-red shadow-red-500/30 dark:hover:shadow-red-600/30 dark:focus:shadow-red-600/30 dark:active:shadow-red-700/30"

      _ ->
        "border-transparent text-white bg-red-600 active:bg-red-700 hover:bg-red-700 active:bg-green-700 focus:bg-red-700"
    end
  end

  defp get_color_classes(%{color: "neutral", variant: variant}) do
    case variant do
      "outline" ->
        "border-neutral-400 dark:border-neutral-400 dark:hover:border-neutral-300 dark:hover:text-neutral-300 dark:hover:bg-transparent dark:text-neutral-400 hover:border-neutral-600 text-neutral-600 hover:text-neutral-700 active:bg-neutral-200 active:border-neutral-700 hover:bg-neutral-50 focus:border-neutral-700"

      "inverted" ->
        "border-neutral-400 dark:border-neutral-400 dark:hover:border-neutral-700 dark:hover:text-white dark:hover:bg-neutral-700 dark:text-neutral-400 hover:border-neutral-600 text-neutral-600 hover:text-white active:bg-neutral-700 hover:bg-neutral-600 focus:border-neutral-700 focus:shadow-outline-neutral"

      "shadow" ->
        "shadow-xl border-transparent text-white bg-neutral-600 active:bg-neutral-700 hover:bg-neutral-700 focus:bg-neutral-700 active:bg-neutral-800 focus:shadow-outline-neutral shadow-neutral-500/30 dark:hover:shadow-neutral-600/30 dark:focus:shadow-neutral-600/30 dark:active:shadow-neutral-700/30"

      _ ->
        "border-transparent text-white bg-neutral-600 active:bg-neutral-700 hover:bg-neutral-700 active:bg-green-700 focus:bg-neutral-700"
    end
  end

  defp get_spinner_size_classes("xs"), do: "h-3 w-3"
  defp get_spinner_size_classes("sm"), do: "h-4 w-4"
  defp get_spinner_size_classes("md"), do: "h-5 w-5"
  defp get_spinner_size_classes("lg"), do: "h-5 w-5"
  defp get_spinner_size_classes("xl"), do: "h-6 w-6"

  defp get_icon_button_size_classes("xs"), do: "w-4 h-4"
  defp get_icon_button_size_classes("sm"), do: "w-5 h-5"
  defp get_icon_button_size_classes("md"), do: "w-6 h-6"
  defp get_icon_button_size_classes("lg"), do: "w-7 h-7"
  defp get_icon_button_size_classes("xl"), do: "w-8 h-8"

  defp get_icon_button_color_classes("primary"), do: "text-primary-600 dark:text-primary-500"

  defp get_icon_button_color_classes("secondary"),
    do: "text-secondary-600 dark:text-secondary-500"

  defp get_icon_button_color_classes("neutral"), do: "text-neutral-600 dark:text-neutral-500"
  defp get_icon_button_color_classes("info"), do: "text-blue-600 dark:text-blue-500"
  defp get_icon_button_color_classes("success"), do: "text-green-600 dark:text-green-500"
  defp get_icon_button_color_classes("warning"), do: "text-yellow-600 dark:text-yellow-500"
  defp get_icon_button_color_classes("danger"), do: "text-red-600 dark:text-red-500"

  defp get_icon_button_background_color_classes("primary"),
    do: "hover:bg-primary-50 dark:hover:bg-neutral-800"

  defp get_icon_button_background_color_classes("secondary"),
    do: "hover:bg-secondary-50 dark:hover:bg-neutral-800"

  defp get_icon_button_background_color_classes("neutral"),
    do: "hover:bg-neutral-100 dark:hover:bg-neutral-800"

  defp get_icon_button_background_color_classes("info"),
    do: "hover:bg-blue-50 dark:hover:bg-neutral-800"

  defp get_icon_button_background_color_classes("success"),
    do: "hover:bg-green-50 dark:hover:bg-neutral-800"

  defp get_icon_button_background_color_classes("warning"),
    do: "hover:bg-yellow-50 dark:hover:bg-neutral-800"

  defp get_icon_button_background_color_classes("danger"),
    do: "hover:bg-red-50 dark:hover:bg-neutral-800"

  defp get_disabled_classes(true), do: "disabled cursor-not-allowed opacity-50"
  defp get_disabled_classes(false), do: ""
end
