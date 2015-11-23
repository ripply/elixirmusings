defmodule Beermusings.VoteTest do
  use Beermusings.ModelCase

  alias Beermusings.Vote

  @valid_attrs %{weight: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Vote.changeset(%Vote{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Vote.changeset(%Vote{}, @invalid_attrs)
    refute changeset.valid?
  end
end
