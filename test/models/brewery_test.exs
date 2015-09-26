defmodule Beermusings.BreweryTest do
  use Beermusings.ModelCase

  alias Beermusings.Brewery

  @valid_attrs %{add_user: 42, address1: "some content", address2: "some content", city: "some content", code: "some content", country: "some content", descript: "some content", filepath: "some content", last_mod: "2010-04-17 14:00:00", name: "some content", phone: "some content", state: "some content", website: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Brewery.changeset(%Brewery{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Brewery.changeset(%Brewery{}, @invalid_attrs)
    refute changeset.valid?
  end
end
