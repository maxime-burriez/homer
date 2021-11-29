defmodule Homer.Search do
  @moduledoc """
  The Search context.
  """

  import Ecto.Query, warn: false
  alias Homer.Repo

  alias Homer.Search.OfferRequest

  @doc """
  Returns the list of offer_requests.

  ## Examples

      iex> list_offer_requests()
      [%OfferRequest{}, ...]

  """
  def list_offer_requests do
    Repo.all(OfferRequest)
  end

  @doc """
  Gets a single offer_request.

  Raises `Ecto.NoResultsError` if the Offer request does not exist.

  ## Examples

      iex> get_offer_request!(123)
      %OfferRequest{}

      iex> get_offer_request!(456)
      ** (Ecto.NoResultsError)

  """
  def get_offer_request!(id), do: Repo.get!(OfferRequest, id)

  @doc """
  Creates a offer_request.

  ## Examples

      iex> create_offer_request(%{field: value})
      {:ok, %OfferRequest{}}

      iex> create_offer_request(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_offer_request(attrs \\ %{}) do
    %OfferRequest{}
    |> OfferRequest.create_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a offer_request.

  ## Examples

      iex> update_offer_request(offer_request, %{field: new_value})
      {:ok, %OfferRequest{}}

      iex> update_offer_request(offer_request, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_offer_request(%OfferRequest{} = offer_request, attrs) do
    offer_request
    |> OfferRequest.update_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a offer_request.

  ## Examples

      iex> delete_offer_request(offer_request)
      {:ok, %OfferRequest{}}

      iex> delete_offer_request(offer_request)
      {:error, %Ecto.Changeset{}}

  """
  def delete_offer_request(%OfferRequest{} = offer_request) do
    Repo.delete(offer_request)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking offer_request changes.

  ## Examples

      iex> change_offer_request(offer_request)
      %Ecto.Changeset{data: %OfferRequest{}}

  """
  def change_offer_request(%OfferRequest{} = offer_request, attrs \\ %{}) do
    OfferRequest.changeset(offer_request, attrs)
  end
end
