defmodule Crm.Chats.Messages do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :content, :string
    field :sender_avito_url, :string

    timestamps()
  end

  @doc false
  def changeset(messages, attrs) do
    messages
    |> cast(attrs, [:content, :sender_avito_url])
    |> validate_required([:content, :sender_avito_url])
  end
end
