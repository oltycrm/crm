defmodule CrmWeb.Components.Container do
  use Phoenix.Component

  import CrmWeb.Components.Helpers

  # prop max_width, :string, options: ["sm", "md", "lg", "xl", "full"]
  # prop class, :string
  # prop no_padding_on_mobile, :boolean
  def container(assigns) do
    assigns =
      assigns
      |> assign_new(:max_width, fn -> "lg" end)
      |> assign_new(:class, fn -> "" end)
      |> assign_new(:no_padding_on_mobile, fn -> false end)
      |> assign_rest(~w(max_width class no_padding_on_mobile)a)

    ~H"""
    <div
      {@rest}
      class={
        build_class([
          "mx-auto sm:px-6 lg:px-8 w-full",
          get_width_class(@max_width),
          get_padding_class(@no_padding_on_mobile),
          @class
        ])
      }
    >
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  defp get_width_class(max_width) do
    case max_width do
      "sm" -> "max-w-3xl"
      "md" -> "max-w-5xl"
      "lg" -> "max-w-7xl"
      "xl" -> "max-w-[85rem]"
      "full" -> "max-w-full"
    end
  end

  defp get_padding_class(no_padding_on_mobile) do
    if no_padding_on_mobile, do: "", else: "px-4"
  end
end
