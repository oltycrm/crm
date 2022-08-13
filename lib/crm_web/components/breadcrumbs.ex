defmodule CrmWeb.Components.Breadcrumbs do
  use Phoenix.Component
  import CrmWeb.Components.Helpers
  alias CrmWeb.Components.Heroicons
  alias CrmWeb.Components.Link

  # Example:
  # <.breadcrumbs separator="chevron" links={[
  #   %{ label: "Link 1", to: "/" },
  #   %{ label: "Link 1", to: "/", link_type: "patch|a|redirect" }
  # ]}/>
  # prop links, :list
  # prop separator, :string, options: ["slash", "chevron"]
  def breadcrumbs(assigns) do
    assigns =
      assigns
      |> assign_new(:separator, fn -> "slash" end)
      |> assign_new(:class, fn -> "" end)
      |> assign_new(:link_class, fn -> "" end)
      |> assign_rest(~w(separator class link_class links)a)

    ~H"""
    <div {@rest} class={"#{@class} flex items-center"}>
      <%= for {link, counter} <- Enum.with_index(@links) do %>
        <%= if counter > 0 do %>
          <.separator type={@separator} />
        <% end %>

        <Link.link
          link_type={link[:link_type] || "a"}
          to={link.to}
          class={get_breadcrumb_classes(@link_class)}
        >
          <%= link.label %>
        </Link.link>
      <% end %>
    </div>
    """
  end

  defp separator(%{type: "slash"} = assigns) do
    ~H"""
    <div class="px-5 text-lg text-neutral-300">/</div>
    """
  end

  defp separator(%{type: "chevron"} = assigns) do
    ~H"""
    <div class="px-3 text-neutral-300">
      <Heroicons.Solid.chevron_right class="w-6 h-6" />
    </div>
    """
  end

  defp get_breadcrumb_classes(user_classes),
    do: "hover:underline flex text-neutral-500 dark:text-neutral-400 #{user_classes}"
end
