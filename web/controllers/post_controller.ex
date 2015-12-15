defmodule Beermusings.PostController do
  use Beermusings.Web, :controller
  use Timex

  import Ecto.Query, only: [from: 2]

  alias Beermusings.Post
  alias Beermusings.Beer
  alias Beermusings.Comment

  plug :scrub_params, "post" when action in [:create, :update]

  def index(conn, _params) do
    now = Date.local
    date(conn, %{"year" => now.year, "month" => now.month})
  end

  def date(conn, %{"year" => year, "month" => month}) when is_integer(year) do
    now = Date.local
    start_time = Date.from({year, month, 1})
    |> DateConvert.to_erlang_datetime
    |> Ecto.DateTime.from_erl
    # Note that specifying the day higher than is in the month will max out the day to that specific month's maximum
    end_time = Date.from({{year, month, 40}, {23, 59, 59}})
    |> DateConvert.to_erlang_datetime
    |> Ecto.DateTime.from_erl
    if (end_time.month != month) do
      throw :error
    end

    IO.inspect(start_time)
    IO.inspect(end_time)

    query = from post in Post,
    where: post.inserted_at > ^start_time,#datetime_add(^Ecto.DateTime.utc, -1, "month"),
    where: post.inserted_at < ^end_time,
    order_by: post.inserted_at

    posts = Repo.all(query)
    |> Repo.preload(:comments)
    |> Repo.preload(:beer)
    |> Repo.preload(:votes)

    # Sorts by voted weight
    posts = Enum.sort_by posts, fn(post) -> List.foldl(post.votes, 0, fn(vote, acc) -> acc + vote.weight end) end, &>=/2
    now = Date.from({year, month, 0})
    prev = Date.shift(now, months: -1)
    next = Date.shift(now, months: 1)
    render(conn, "index.html", posts: posts, month: month, year: year, prev: prev, next: next)
  end

  def date(conn, %{"year" => year, "month" => month}) do
    IO.inspect(year)
    {year, _} = Integer.parse(year)
    {month, _} = Integer.parse(month)
    date(conn, %{"year" => year, "month" => month})
  end

  def get_beers() do
    query = from beer in Beer,
    order_by: beer.name

    beers = Repo.all(query)
  end

  def new(conn, _params) do
    beers = get_beers()
    changeset = Post.changeset(%Post{})
    render(conn, "new_beers.html", changeset: changeset, beers: beers, beer_id: nil)
  end

  def new(conn, %{"beer_id" => beer_id}) do
    changeset = Repo.get(Beer, beer_id)
    |> Ecto.Model.build(:posts)
    |> Post.changeset()
    render(conn, "new.html", changeset: changeset, beer_id: beer_id)
  end

  def create(conn, %{"post" => post_params, "beer_id" => beer_id}) do
    beer = Repo.get(Beer, beer_id)
    changeset = Ecto.Model.build(beer, :posts)
    |> Post.changeset(post_params)

    case Repo.insert(changeset) do
      {:ok, _post} ->
        conn
        |> put_flash(:info, "Post created successfully.")
        |> redirect(to: post_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    post = Repo.get!(Post, id)
    |> Repo.preload(:comments)
    |> Repo.preload(:beer)

    comment_changeset = Comment.changeset(%Comment{})

    render(conn, "show.html", post: post, comment_changeset: comment_changeset)
  end

  def edit(conn, %{"id" => id}) do
    beers = get_beers()
    post = Repo.get!(Post, id)
    |> Repo.preload(:beer)
    changeset = Post.changeset(post)
    render(conn, "edit.html", post: post, changeset: changeset, beers: beers, beer_id: post.beer_id)
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Repo.get!(Post, id)
    changeset = Post.changeset(post, post_params)

    case Repo.update(changeset) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post updated successfully.")
        |> redirect(to: post_path(conn, :show, post))
      {:error, changeset} ->
        render(conn, "edit.html", post: post, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    post = Repo.get!(Post, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(post)

    conn
    |> put_flash(:info, "Post deleted successfully.")
    |> redirect(to: post_path(conn, :index))
  end
end
