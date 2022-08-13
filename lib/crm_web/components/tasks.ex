defmodule CrmWeb.Components.Tasks do
  use Phoenix.Component
  import CrmWeb.Components.Helpers

  import CrmComponents.Link
  import CrmComponents.SlideOver

  def tasks(assigns) do
    ~H"""
    <div class="h-full flex">
      <main class="h-full flex flex-wrap overflow-auto w-full lg:w-auto lg:mx-auto">
        <%= render_slot(@inner_block) %>
      </main>
    </div>
    """
  end

  def task_group(assigns) do
    assigns =
      assigns
      |> assign_new(:class, fn -> "" end)

    ~H"""
    <section class={
      build_class([
        "flex flex-col m-2  rounded-md overflow w-full  lg:w-96",
        assigns[:class]
      ])
    }>
      <h3 class="flex-shrink-0 pt-3 pb-1 px-3 text-sm font-medium text-neutral-900">
        <%= @task_group_title %>
      </h3>
      <div class="flex-1 min-h-0 overflow-y-auto w-full">
        <ul class="pt-1 pb-3 px-3 w-full">
          <%= render_slot(@inner_block) %>
        </ul>
      </div>
    </section>
    """
  end

  def task(assigns) do
    ~H"""
    <li class="mt-3 max-w-8 w-full ">
      <.link link_type="live_redirect" to={@to} class="block p-4 bg-white rounded-md shadow w-full">
        <div class="flex justify-between w-full">
          <p class="text-sm font-medium leading-snug text-neutral-900 shrink w-full">
            <%= @title %>
          </p>
          <p class="text-sm font-medium text-right leading-snug text-neutral-900 shrink w-full">
            <%= @manager %>
          </p>
        </div>
        <div class="flex justify-between mt-5">
          <div class="text-sm text-neutral-600">
            <time datetime="2020-10-12"><%= @due_date %></time>
          </div>
          <div></div>
        </div>
      </.link>
    </li>
    """
  end

  def new_task_slide_over(assigns) do
    ~H"""
    <.slide_over id="asdfadsf" title="shit">
      <%= render_slot(@inner_block) %>
    </.slide_over>
    """
  end
end
