defmodule Homer.SearchFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Homer.Search` context.
  """

  @doc """
  Generate a offer_request.
  """
  def offer_request_fixture(attrs \\ %{}) do
    {:ok, offer_request} =
      attrs
      |> Enum.into(%{
        departure_date: ~D[2021-11-20],
        destination: "JFK",
        origin: "CDG"
      })
      |> Homer.Search.create_offer_request()

    offer_request
  end
end
