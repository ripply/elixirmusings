defmodule Beermusings.Vote do
  use Beermusings.Web, :model

  schema "votes" do
    field :weight, :integer
    belongs_to :post, Beermusings.Post

    timestamps
  end

  @required_fields ~w(weight)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
