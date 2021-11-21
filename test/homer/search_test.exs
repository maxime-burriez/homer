defmodule Homer.SearchTest do
  use Homer.DataCase

  alias Homer.Search

  describe "offer_requests" do
    alias Homer.Search.OfferRequest

    import Homer.SearchFixtures

    @invalid_attrs %{
      allowed_airlines: nil,
      departure_date: nil,
      destination: nil,
      origin: nil,
      sort_by: nil
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
      valid_attrs = %{
        allowed_airlines: [],
        departure_date: ~D[2021-11-20],
        destination: "some destination",
        origin: "some origin",
        sort_by: "some sort_by"
      }

      assert {:ok, %OfferRequest{} = offer_request} = Search.create_offer_request(valid_attrs)
      assert offer_request.allowed_airlines == []
      assert offer_request.departure_date == ~D[2021-11-20]
      assert offer_request.destination == "some destination"
      assert offer_request.origin == "some origin"
      assert offer_request.sort_by == "some sort_by"
    end

    test "create_offer_request/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Search.create_offer_request(@invalid_attrs)
    end

    test "update_offer_request/2 with valid data updates the offer_request" do
      offer_request = offer_request_fixture()

      update_attrs = %{
        allowed_airlines: [],
        departure_date: ~D[2021-11-21],
        destination: "some updated destination",
        origin: "some updated origin",
        sort_by: "some updated sort_by"
      }

      assert {:ok, %OfferRequest{} = offer_request} =
               Search.update_offer_request(offer_request, update_attrs)

      assert offer_request.allowed_airlines == []
      assert offer_request.departure_date == ~D[2021-11-21]
      assert offer_request.destination == "some updated destination"
      assert offer_request.origin == "some updated origin"
      assert offer_request.sort_by == "some updated sort_by"
    end

    test "update_offer_request/2 with invalid data returns error changeset" do
      offer_request = offer_request_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Search.update_offer_request(offer_request, @invalid_attrs)

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
