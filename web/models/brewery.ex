defmodule Beermusings.Brewery do
  use Beermusings.Web, :model

  schema "brewery" do
    field :name, :string
    field :address1, :string
    field :address2, :string
    field :city, :string
    field :state, :string
    field :code, :string
    field :country, :string
    field :phone, :string
    field :website, :string
    field :filepath, :string
    field :descript, :string
    field :add_user, :integer
    field :last_mod, Ecto.DateTime

    timestamps
  end

  @required_fields ~w(name address1 address2 city state code country phone website filepath descript add_user last_mod)
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
