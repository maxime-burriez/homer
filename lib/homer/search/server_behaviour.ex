defmodule Homer.Search.ServerBehaviour do
  @moduledoc """
  Homer.Search.ServerBehaviour
  """

  @callback start_link({OfferRequest.t(), providers :: [module()]}) ::
              {:ok, pid()} | {:error, any()}

  @doc """
  Get the filtered and sorted list of offers.
  """
  @callback list_offers(pid :: pid(), limit :: integer()) :: {:ok, [Offer.t()]} | {:error, any()}

  @doc """
  Notify the server that an offer request has been updated.
  """
  @callback offer_request_updated(pid :: pid(), OfferRequest.t()) :: :ok
end
