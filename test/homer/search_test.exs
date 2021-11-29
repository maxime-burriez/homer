defmodule Homer.SearchTest do
  use Homer.DataCase

  alias Homer.Search

  describe "offer_requests" do
    alias Homer.Search.OfferRequest

    import Homer.SearchFixtures

    @create_attrs %{
      departure_date: ~D[2021-11-20],
      destination: "JFK",
      origin: "CDG"
    }

    @update_attrs %{
      allowed_airlines: ["BA"],
      sort_by: :total_duration_asc
    }

    @invalid_create_attrs %{
      departure_date: nil,
      destination: nil,
      origin: nil
    }

    @invalid_update_attrs %{
      allowed_airlines: [42],
      sort_by: 'bad_sort'
    }

    test "list_offer_requests/0 returns all offer_requests" do
      offer_request = offer_request_fixture()
      assert Search.list_offer_requests() == [offer_request]
    end

    test "get_offer_request!/1 returns the offer_request with given id" do
      offer_request = offer_request_fixture()
      assert Search.get_offer_request!(offer_request.id) == offer_request
    end

    test "create_offer_request/1 with valid data creates a offer_request" do
      assert {:ok, %OfferRequest{} = offer_request} = Search.create_offer_request(@create_attrs)
      assert offer_request.allowed_airlines == nil
      assert offer_request.departure_date == @create_attrs.departure_date
      assert offer_request.destination == @create_attrs.destination
      assert offer_request.origin == @create_attrs.origin
      assert offer_request.sort_by == :total_amount_asc
    end

    test "create_offer_request/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Search.create_offer_request(@invalid_create_attrs)
    end

    test "update_offer_request/2 with valid data updates the offer_request" do
      offer_request = offer_request_fixture()

      assert {:ok, %OfferRequest{} = offer_request} =
               Search.update_offer_request(offer_request, @update_attrs)

      assert offer_request.allowed_airlines == @update_attrs.allowed_airlines
      assert offer_request.sort_by == @update_attrs.sort_by
    end

    test "update_offer_request/2 with invalid data returns error changeset" do
      offer_request = offer_request_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Search.update_offer_request(offer_request, @invalid_update_attrs)

      assert offer_request == Search.get_offer_request!(offer_request.id)
    end

    test "delete_offer_request/1 deletes the offer_request" do
      offer_request = offer_request_fixture()
      assert {:ok, %OfferRequest{}} = Search.delete_offer_request(offer_request)
      assert_raise Ecto.NoResultsError, fn -> Search.get_offer_request!(offer_request.id) end
    end

    test "change_offer_request/1 returns a offer_request changeset" do
      offer_request = offer_request_fixture()
      assert %Ecto.Changeset{} = Search.change_offer_request(offer_request)
    end
  end
end
