defmodule Beermusings.Router do
  use Beermusings.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Beermusings do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/beers", BeerController do
      post "/post", PostController, :create
      get "/post", PostController, :new
    end
    resources "/brewery", BreweryController
    resources "/comment", CommentController
    resources "/posts", PostController do
      post "/comment", CommentController, :create
      get "/comment", CommentController, :new
      get "/vote", VoteController, :upvote
      get "/downvote", VoteController, :downvote
    end

  end

  # Other scopes may use custom stacks.
  # scope "/api", Beermusings do
  #   pipe_through :api
  # end
end
