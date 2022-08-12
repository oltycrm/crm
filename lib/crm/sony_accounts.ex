defmodule Crm.SonyAccounts do
  @moduledoc """
  The SonyAccounts context.
  """

  import Ecto.Query, warn: false
  alias Crm.Repo

  alias Crm.SonyAccounts.SonyAccount
  alias Crm.Clients.Client

  @doc """
  Returns the list of sony_accounts.

  ## Examples

      iex> list_sony_accounts()
      [%SonyAccount{}, ...]

  """
  def list_sony_accounts do
    Repo.all(SonyAccount)
  end

  @doc """
  Gets a single sony_account.

  Raises `Ecto.NoResultsError` if the Sony account does not exist.

  ## Examples

      iex> get_sony_account!(123)
      %SonyAccount{}

      iex> get_sony_account!(456)
      ** (Ecto.NoResultsError)

  """
  def get_sony_account!(id), do: Repo.get!(SonyAccount, id)

  @doc """
  Creates a sony_account.

  ## Examples

      iex> create_sony_account(%{field: value})
      {:ok, %SonyAccount{}}

      iex> create_sony_account(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_sony_account(%Crm.Clients.Client{} = client, attrs \\ %{}) do
    attrs = Map.put(attrs, "client_id", client.id)

    %SonyAccount{}
    |> SonyAccount.changeset(attrs)
    # |> Ecto.Changeset.put_assoc(:client, client)
    |> Repo.insert()
  end

  @doc """
  Updates a sony_account.

  ## Examples

      iex> update_sony_account(sony_account, %{field: new_value})
      {:ok, %SonyAccount{}}

      iex> update_sony_account(sony_account, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_sony_account(%Crm.Clients.Client{} = client, %SonyAccount{} = sony_account, attrs) do
    sony_account
    |> SonyAccount.changeset(attrs)
    # |> Ecto.Changeset.put_assoc(:client, client)
    |> Repo.update()
  end

  @doc """
  Deletes a sony_account.

  ## Examples

      iex> delete_sony_account(sony_account)
      {:ok, %SonyAccount{}}

      iex> delete_sony_account(sony_account)
      {:error, %Ecto.Changeset{}}

  """
  def delete_sony_account(%SonyAccount{} = sony_account) do
    Repo.delete(sony_account)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking sony_account changes.

  ## Examples

      iex> change_sony_account(sony_account)
      %Ecto.Changeset{data: %SonyAccount{}}

  """
  def change_sony_account(%SonyAccount{} = sony_account, attrs \\ %{}) do
    SonyAccount.changeset(sony_account, attrs)
  end

  def list_sony_accounts_by_client_id!(client_id) do
    Repo.all(from(sa in SonyAccount, where: sa.client_id == ^client_id))
  end

  def get_client_by_sony_account_id!(id) do
    sony_account = get_sony_account!(id)

    client =
      Repo.one(
        from(
          client in Client,
          where: client.id == ^sony_account.client_id
        )
      )

    client_id = client.id

    Repo.get!(Client, client_id)
  end
end
