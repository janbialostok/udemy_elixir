defmodule Discuss.Router do
  use Discuss.Web, :router

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

  scope "/", Discuss do
    pipe_through :browser # Use the default browser stack
    # this still needs to be defined even with resources defined because it slightly breaks RESTful conventions
    get "/", TopicController, :index
    # get "/topics/new", TopicController, :new
    # get "/topics/:id/edit", TopicController, :edit
    # post "/topics", TopicController, :create
    # put "/topics/:id", TopicController, :update
    # the below line mimics the behaviour above so long as the RESTful design the followed exactly like above
    resources "/topics", TopicController
  end

  scope "/auth", Discuss do
    pipe_through :browser

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end

  # Other scopes may use custom stacks.
  # scope "/api", Discuss do
  #   pipe_through :api
  # end
end
