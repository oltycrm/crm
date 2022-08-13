defmodule CrmWeb.Components.Table do
  use Phoenix.Component

  import CrmWeb.Components.Avatar
  import CrmWeb.Components.Helpers

  def table(assigns) do
    assigns =
      assigns
      |> assign_new(:class, fn -> "" end)
      |> assign_new(:rest, fn ->
        assigns_to_attributes(assigns, ~w(
          class
        )a)
      end)

    ~H"""
    <table
      class={
        build_class([
          "min-w-full overflow-hidden divide-y ring-1 ring-neutral-200 dark:ring-0 divide-neutral-200 rounded-sm table-auto dark:divide-y-0 dark:divide-neutral-800 sm:rounded",
          @class
        ])
      }
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </table>
    """
  end

  def th(assigns) do
    assigns =
      assigns
      |> assign_new(:class, fn -> "" end)
      |> assign_new(:rest, fn ->
        assigns_to_attributes(assigns, ~w(
          class
        )a)
      end)

    ~H"""
    <th
      class={
        build_class(
          [
            "px-6 py-3 text-xs font-medium tracking-wider text-left text-neutral-700 uppercase bg-neutral-50 dark:bg-neutral-700 dark:text-neutral-300",
            @class
          ],
          " "
        )
      }
      {@rest}
    >
      <%= if @inner_block do %>
        <%= render_slot(@inner_block) %>
      <% end %>
    </th>
    """
  end

  def tr(assigns) do
    assigns =
      assigns
      |> assign_new(:class, fn -> "" end)
      |> assign_new(:rest, fn ->
        assigns_to_attributes(assigns, ~w(
          class
        )a)
      end)

    ~H"""
    <tr
      class={
        build_class([
          "border-b dark:border-neutral-700 bg-white dark:bg-neutral-800 last:border-none",
          @class
        ])
      }
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </tr>
    """
  end

  def td(assigns) do
    assigns =
      assigns
      |> assign_new(:class, fn -> "" end)
      |> assign_new(:rest, fn ->
        assigns_to_attributes(assigns, ~w(
          class
        )a)
      end)

    ~H"""
    <td
      class={
        build_class(
          [
            "px-6 py-4 text-sm text-neutral-500 dark:text-neutral-400",
            @class
          ],
          " "
        )
      }
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </td>
    """
  end

  def user_inner_td(assigns) do
    assigns =
      assigns
      |> assign_new(:class, fn -> "" end)
      |> assign_new(:avatar_assigns, fn -> nil end)
      |> assign_rest(~w(class avatar_assigns label sub_label)a)

    ~H"""
    <div class={@class} {@rest}>
      <div class="flex items-center gap-3">
        <%= if @avatar_assigns do %>
          <.avatar {@avatar_assigns} />
        <% end %>

        <div class="flex flex-col overflow-hidden">
          <div class="overflow-hidden font-medium text-neutral-900 whitespace-nowrap text-ellipsis dark:text-neutral-300">
            <%= @label %>
          </div>
          <div class="overflow-hidden font-normal text-neutral-500 whitespace-nowrap text-ellipsis">
            <%= @sub_label %>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
