defmodule Crm.Cards.Card do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cards" do
    field :balance, :float
    field :bank, :string
    field :code, :integer
    field :day, :integer
    field :card_number, :string
    field :month, :integer
    field :name, :string
    field :status, Ecto.Enum, values: [:Платит, :Привязывается, :Пополняет, :Мертвая]
    field :system, Ecto.Enum, values: [:visa, :master, :maestro]
    field :top, :boolean, default: false
    field :type, Ecto.Enum, values: [:virtual, :physical]
    field :year, :integer
    field :last_transaction, :naive_datetime
    field :in_use, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset(card, attrs) do
    card
    |> cast(attrs, [
      :name,
      :card_number,
      :month,
      :year,
      :code,
      :status,
      # :balance,
      :type,
      :bank,
      :system,
      :top
    ])
    |> validate_required([
      :name,
      :card_number,
      # :month,
      # :year,
      # :code,
      :status,
      # :balance,
      :type,
      :bank
    ])
  end

  def last_transaction_changeset(card, attrs) do
    card
    |> cast(attrs, [:last_transaction])
  end

  def in_use_changeset(card, attrs) do
    card
    |> cast(attrs, [:in_use, :status])
  end
end
