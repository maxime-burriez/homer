defmodule HomerWeb.OfferRequestLiveTest do
  use HomerWeb.ConnCase

  import Phoenix.LiveViewTest
  import Homer.SearchFixtures

  @create_attrs %{
    allowed_airlines: [],
    departure_date: %{day: 20, month: 11, year: 2021},
    destination: "some destination",
    origin: "some origin",
    sort_by: "some sort_by"
  }
  @update_attrs %{
    allowed_airlines: [],
    departure_date: %{day: 21, month: 11, year: 2021},
    destination: "some updated destination",
    origin: "some updated origin",
    sort_by: "some updated sort_by"
  }
  @invalid_attrs %{
    allowed_airlines: [],
    departure_date: %{day: 30, month: 2, year: 2021},
    destination: nil,
    origin: nil,
    sort_by: nil
  }

  defp create_offer_request(_) do
    offer_request = offer_request_fixture()
    %{offer_request: offer_request}
  end

  describe "Index" do
    setup [:create_offer_request]

    test "lists all offer_requests", %{conn: conn, offer_request: offer_request} do
      {:ok, _index_live, html} = live(conn, Routes.offer_request_index_path(conn, :index))

      assert html =~ "Listing Offer requests"
      assert html =~ offer_request.destination
    end

    test "saves new offer_request", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.offer_request_index_path(conn, :index))

      assert index_live |> element("a", "New Offer request") |> render_click() =~
               "New Offer request"

      assert_patch(index_live, Routes.offer_request_index_path(conn, :new))

      assert index_live
             |> form("#offer_request-form", offer_request: @invalid_attrs)
             |> render_change() =~ "is invalid"

      {:ok, _, html} =
        index_live
        |> form("#offer_request-form", offer_request: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.offer_request_index_path(conn, :index))

      assert html =~ "Offer request created successfully"
      assert html =~ "some destination"
    end

    test "updates offer_request in listing", %{conn: conn, offer_request: offer_request} do
      {:ok, index_live, _html} = live(conn, Routes.offer_request_index_path(conn, :index))

      assert index_live
             |> element("#offer_request-#{offer_request.id} a", "Edit")
             |> render_click() =~
               "Edit Offer request"

      assert_patch(index_live, Routes.offer_request_index_path(conn, :edit, offer_request))

      assert index_live
             |> form("#offer_request-form", offer_request: @invalid_attrs)
             |> render_change() =~ "is invalid"

      {:ok, _, html} =
        index_live
        |> form("#offer_request-form", offer_request: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.offer_request_index_path(conn, :index))

      assert html =~ "Offer request updated successfully"
      assert html =~ "some updated destination"
    end

    test "deletes offer_request in listing", %{conn: conn, offer_request: offer_request} do
      {:ok, index_live, _html} = live(conn, Routes.offer_request_index_path(conn, :index))

      assert index_live
             |> element("#offer_request-#{offer_request.id} a", "Delete")
             |> render_click()

      refute has_element?(index_live, "#offer_request-#{offer_request.id}")
    end
  end

  describe "Show" do
    setup [:create_offer_request]

    test "displays offer_request", %{conn: conn, offer_request: offer_request} do
      {:ok, _show_live, html} =
        live(conn, Routes.offer_request_show_path(conn, :show, offer_request))

      assert html =~ "Show Offer request"
      assert html =~ offer_request.destination
    end

    test "updates offer_request within modal", %{conn: conn, offer_request: offer_request} do
      {:ok, show_live, _html} =
        live(conn, Routes.offer_request_show_path(conn, :show, offer_request))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Offer request"

      assert_patch(show_live, Routes.offer_request_show_path(conn, :edit, offer_request))

      assert show_live
             |> form("#offer_request-form", offer_request: @invalid_attrs)
             |> render_change() =~ "is invalid"

      {:ok, _, html} =
        show_live
        |> form("#offer_request-form", offer_request: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.offer_request_show_path(conn, :show, offer_request))

      assert html =~ "Offer request updated successfully"
      assert html =~ "some updated destination"
    end
  end
end
