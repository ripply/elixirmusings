defmodule Beermusings.Beer do
  use Beermusings.Web, :model

  schema "beers" do
    field :name, :string
    field :cat_id, :integer
    field :style_id, :integer
    field :abv, :float
    field :ibu, :float
    field :srm, :float
    field :upc, :integer
    field :filepath, :string
    field :descript, :string
    field :add_user, :integer
    field :last_mod, Ecto.DateTime
    belongs_to :brewery, Beermusings.Brewery

    has_many :posts, Beermusings.Post
    timestamps
  end

  @required_fields ~w(brewery_id name cat_id style_id abv ibu srm upc filepath descript add_user last_mod)
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
