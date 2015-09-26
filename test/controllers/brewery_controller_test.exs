defmodule Beermusings.BreweryControllerTest do
  use Beermusings.ConnCase

  alias Beermusings.Brewery
  @valid_attrs %{add_user: 42, address1: "some content", address2: "some content", city: "some content", code: "some content", country: "some content", descript: "some content", filepath: "some content", last_mod: "2010-04-17 14:00:00", name: "some content", phone: "some content", state: "some content", website: "some content"}
  @invalid_attrs %{}

  setup do
    conn = conn()
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, brewery_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing brewery"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, brewery_path(conn, :new)
    assert html_response(conn, 200) =~ "New brewery"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, brewery_path(conn, :create), brewery: @valid_attrs
    assert redirected_to(conn) == brewery_path(conn, :index)
    assert Repo.get_by(Brewery, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, brewery_path(conn, :create), brewery: @invalid_attrs
    assert html_response(conn, 200) =~ "New brewery"
  end

  test "shows chosen resource", %{conn: conn} do
    brewery = Repo.insert! %Brewery{}
    conn = get conn, brewery_path(conn, :show, brewery)
    assert html_response(conn, 200) =~ "Show brewery"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, brewery_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    brewery = Repo.insert! %Brewery{}
    conn = get conn, brewery_path(conn, :edit, brewery)
    assert html_response(conn, 200) =~ "Edit brewery"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    brewery = Repo.insert! %Brewery{}
    conn = put conn, brewery_path(conn, :update, brewery), brewery: @valid_attrs
    assert redirected_to(conn) == brewery_path(conn, :show, brewery)
    assert Repo.get_by(Brewery, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    brewery = Repo.insert! %Brewery{}
    conn = put conn, brewery_path(conn, :update, brewery), brewery: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit brewery"
  end

  test "deletes chosen resource", %{conn: conn} do
    brewery = Repo.insert! %Brewery{}
    conn = delete conn, brewery_path(conn, :delete, brewery)
    assert redirected_to(conn) == brewery_path(conn, :index)
    refute Repo.get(Brewery, brewery.id)
  end
end
