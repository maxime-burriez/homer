defmodule Homer.Search.ProviderBehaviour do
  alias Homer.Search.{OfferRequest, Offer}

  @callback fetch_offers(OfferRequest.t()) :: {:ok, [Offer.t()]} | {:error, any()}
end
