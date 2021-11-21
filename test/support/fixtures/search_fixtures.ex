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
        allowed_airlines: [],
        departure_date: ~D[2021-11-20],
        destination: "some destination",
        origin: "some origin",
        sort_by: "some sort_by"
      })
      |> Homer.Search.create_offer_request()

    offer_request
  end
end
