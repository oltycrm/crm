defmodule Crm.Deals do
  @moduledoc """
  The Deals context.
  """

  import Ecto.Query, warn: false
  alias Crm.Repo

  alias Crm.Deals.Deal

  @doc """
  Returns the list of deals.

  ## Examples

      iex> list_deals()
      [%Deal{}, ...]

  """
  def list_deals do
    Repo.all(
      from(d in Deal,
        order_by: d.updated_at
      )
    )
  end

  def list_new_delas do
    Repo.all(
      from(d in Deal,
        where: d.status == :lead,
        order_by: [desc: d.updated_at]
      )
    )
  end

  @doc """
  Gets a single deal.

  Raises `Ecto.NoResultsError` if the Deal does not exist.

  ## Examples

      iex> get_deal!(123)
      %Deal{}

      iex> get_deal!(456)
      ** (Ecto.NoResultsError)

  """
  def get_deal!(id), do: Repo.get!(Deal, id)

  @doc """
  Creates a deal.

  ## Examples

      iex> create_deal(%{field: value})
      {:ok, %Deal{}}

      iex> create_deal(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_deal(%Crm.Clients.Client{} = client, attrs \\ %{}) do
    attrs = Map.put(attrs, "client_id", client.id)

    %Deal{}
    |> Deal.changeset(attrs)
    # |> Ecto.Changeset.put_assoc(:client, client)
    # |> Ecto.Changeset.put_assoc(:product, product)
    |> Repo.insert()
  end

  @doc """
  Updates a deal.

  ## Examples

      iex> update_deal(deal, %{field: new_value})
      {:ok, %Deal{}}

      iex> update_deal(deal, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_deal(%Deal{} = deal, attrs) do
    deal
    |> Deal.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a deal.

  ## Examples

      iex> delete_deal(deal)
      {:ok, %Deal{}}

      iex> delete_deal(deal)
      {:error, %Ecto.Changeset{}}

  """
  def delete_deal(%Deal{} = deal) do
    Repo.delete(deal)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking deal changes.

  ## Examples

      iex> change_deal(deal)
      %Ecto.Changeset{data: %Deal{}}

  """
  def change_deal(%Deal{} = deal, attrs \\ %{}) do
    Deal.changeset(deal, attrs)
  end

  def list_deals_by_status(status) do
    Repo.all(
      from(d in Deal,
        where: d.status == ^status,
        order_by: [desc: d.updated_at]
      )
    )
  end

  def list_deals_by_client_id(client_id) do
    Repo.all(
      from(
        d in Deal,
        where: d.client_id == ^client_id,
        order_by: [desc: d.updated_at]
      )
    )
  end
end
