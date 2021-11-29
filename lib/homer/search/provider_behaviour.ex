defmodule Homer.Search.ProviderBehaviour do
  @moduledoc """
  Homer.Search.ProviderBehaviour
  """

  alias Homer.Search.{OfferRequest, Offer}

  @callback fetch_offers(OfferRequest.t()) :: {:ok, [Offer.t()]} | {:error, any()}
end
