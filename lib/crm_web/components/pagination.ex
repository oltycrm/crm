defmodule CrmWeb.Components.Pagination do
  use Phoenix.Component

  alias CrmWeb.Components.Heroicons
  alias CrmWeb.Components.Link

  import CrmWeb.Components.Helpers

  # prop path, :string
  # prop class, :string
  # prop sibling_count, :integer
  # prop boundary_count, :integer
  # prop link_type, :string, options: ["a", "live_patch", "live_redirect"]

  @doc """
  In the `path` param you can specify :page as the place your page number will appear.
  e.g "/posts/:page" => "/posts/1"
  """

  def pagination(assigns) do
    assigns =
      assigns
      |> assign_new(:class, fn -> "" end)
      |> assign_new(:link_type, fn -> "a" end)
      |> assign_new(:sibling_count, fn -> 1 end)
      |> assign_new(:boundary_count, fn -> 1 end)
      |> assign_new(:path, fn -> "/:page" end)
      |> assign_rest(
        ~w(link_type sibling_count boundary_count total_pages current_page path class)a
      )

    ~H"""
    <div {@rest} class={"#{@class} flex"}>
      <ul class="inline-flex -space-x-px text-sm font-medium">
        <%= for item <- get_items(@total_pages, @current_page, @sibling_count, @boundary_count) do %>
          <%= if item.type == "previous" do %>
            <div>
              <Link.link
                link_type={@link_type}
                to={get_path(@path, item.number, @current_page)}
                class="mr-2 inline-flex items-center justify-center rounded leading-5 px-2.5 py-2 bg-white hover:bg-neutral-50 dark:bg-neutral-900 dark:hover:bg-neutral-800 border dark:border-neutral-700 border-neutral-200 text-neutral-600 hover:text-neutral-800"
              >
                <Heroicons.Solid.chevron_left class="w-5 h-5 text-neutral-600 dark:text-neutral-400" />
              </Link.link>
            </div>
          <% end %>

          <%= if item.type == "page" do %>
            <li>
              <%= if item.number == @current_page do %>
                <span class={get_box_class(item, true)}><%= item.number %></span>
              <% else %>
                <Link.link
                  link_type={@link_type}
                  to={get_path(@path, item.number, @current_page)}
                  class={get_box_class(item)}
                >
                  <%= item.number %>
                </Link.link>
              <% end %>
            </li>
          <% end %>

          <%= if item.type == "ellipsis" do %>
            <li>
              <span class="inline-flex items-center justify-center leading-5 px-3.5 py-2 bg-white border dark:bg-neutral-900 dark:border-neutral-700 border-neutral-200 text-neutral-400">
                ...
              </span>
            </li>
          <% end %>

          <%= if item.type == "next" do %>
            <div>
              <Link.link
                link_type={@link_type}
                to={get_path(@path, item.number, @current_page)}
                class="ml-2 inline-flex items-center justify-center rounded leading-5 px-2.5 py-2 bg-white hover:bg-neutral-50 dark:bg-neutral-900 dark:hover:bg-neutral-800 dark:border-neutral-700 border border-neutral-200 text-neutral-600 hover:text-neutral-800"
              >
                <Heroicons.Solid.chevron_right class="w-5 h-5 text-neutral-600 dark:text-neutral-400" />
              </Link.link>
            </div>
          <% end %>
        <% end %>
      </ul>
    </div>
    """
  end

  defp get_items(total_pages, current_page, sibling_count, boundary_count) do
    start_pages = 1..min(boundary_count, total_pages) |> Enum.to_list()
    end_pages_start = max(total_pages - boundary_count + 1, boundary_count + 1)
    end_pages_end = total_pages
    end_pages = end_pages_start..end_pages_end |> Enum.to_list()

    siblings_start =
      max(
        min(current_page - sibling_count, total_pages - boundary_count - sibling_count * 2 - 1),
        boundary_count + 2
      )

    siblings_end =
      min(
        max(current_page + sibling_count, boundary_count + sibling_count * 2 + 2),
        if(length(end_pages) > 0, do: List.first(end_pages) - 2, else: total_pages - 1)
      )

    items = []

    # Previous button
    items =
      if current_page > 1,
        do: items ++ [%{type: "previous", number: current_page - 1}],
        else: items

    # Start pages
    items =
      Enum.reduce(start_pages, items, fn i, acc ->
        acc ++ [%{type: "page", number: i, first: i == 1, only: total_pages == 1}]
      end)

    # First ellipsis
    items =
      if siblings_start > boundary_count + 2,
        do: items ++ [%{type: "ellipsis"}],
        else:
          if(boundary_count + 1 < total_pages - boundary_count,
            do: items ++ [%{type: "page", number: boundary_count + 1}],
            else: items
          )

    # Siblings
    items =
      if siblings_start <= siblings_end do
        Enum.reduce(siblings_start..siblings_end, items, fn i, acc ->
          acc ++ [%{type: "page", number: i}]
        end)
      else
        items
      end

    # Second ellipsis
    items =
      if siblings_end < total_pages - boundary_count - 1,
        do: items ++ [%{type: "ellipsis"}],
        else:
          if(total_pages - boundary_count > boundary_count,
            do: items ++ [%{type: "page", number: total_pages - boundary_count}],
            else: items
          )

    # End pages
    items =
      if end_pages_start <= end_pages_end do
        Enum.reduce(end_pages, items, fn i, acc ->
          acc ++ [%{type: "page", number: i, last: i == total_pages}]
        end)
      else
        items
      end

    # Next button
    items =
      if current_page < total_pages,
        do: items ++ [%{type: "next", number: current_page + 1}],
        else: items

    items
  end

  defp get_box_class(item, is_active \\ false) do
    base_classes =
      "inline-flex items-center justify-center leading-5 px-3.5 py-2 border border-neutral-200 dark:border-neutral-700"

    active_classes =
      if is_active,
        do: "bg-neutral-100 text-neutral-800 dark:bg-neutral-800 dark:text-neutral-300",
        else:
          "bg-white text-neutral-600 hover:bg-neutral-50 hover:text-neutral-800 dark:bg-neutral-900 dark:text-neutral-400 dark:hover:bg-neutral-800 dark:hover:text-neutral-400"

    rounded_classes =
      cond do
        item[:only] ->
          "rounded"

        item[:first] ->
          "rounded-l "

        item[:last] ->
          "rounded-r"

        true ->
          ""
      end

    build_class([base_classes, active_classes, rounded_classes])
  end

  defp get_path(path, "previous", current_page) do
    String.replace(path, ":page", Integer.to_string(current_page - 1))
  end

  defp get_path(path, "next", current_page) do
    String.replace(path, ":page", Integer.to_string(current_page + 1))
  end

  defp get_path(path, page_number, _current_page) do
    String.replace(path, ":page", Integer.to_string(page_number))
  end
end
