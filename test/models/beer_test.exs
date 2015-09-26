defmodule Beermusings.BeerTest do
  use Beermusings.ModelCase

  alias Beermusings.Beer

  @valid_attrs %{abv: "120.5", add_user: 42, brewery_id: 42, cat_id: 42, descript: "some content", filepath: "some content", ibu: "120.5", last_mod: "2010-04-17 14:00:00", name: "some content", srm: "120.5", style_id: 42, upc: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Beer.changeset(%Beer{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Beer.changeset(%Beer{}, @invalid_attrs)
    refute changeset.valid?
  end
end
