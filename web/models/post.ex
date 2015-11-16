defmodule Beermusings.Post do
  use Beermusings.Web, :model

  schema "posts" do
    field :title, :string
    field :content, :string
    belongs_to :beer, Beermusings.Beer

    has_many :comments, Beermusings.Comment, foreign_key: :post_id
    timestamps
  end

  @required_fields ~w(title content)
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
