defmodule CrmWeb.Components do
  defmacro __using__(_) do
    quote do
      # alias CrmWeb.Components.Heroicons

      import CrmWeb.Components.{
        # Alert,
        # Badge,
        # Button,
        # Container,
        # Dropdown,
        # Form,
        # Loading,
        # Typography,
        # Avatar,
        # Progress,
        # Breadcrumbs,
        # Pagination,
        # Link,
        # Modal,
        # SlideOver,
        # Tabs,
        # Card,
        # Table,
        # Accordion
        Wrapper,
        Tasks,
        SectionHeadings
      }
    end
  end
end
