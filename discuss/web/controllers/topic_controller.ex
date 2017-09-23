defmodule Discuss.TopicController do
  # Elixir does not use any class inheritance and so there a few other methods provided for reuse of code
  # import
  # takes all of the functions out of a given module into the module in which the statement is being used
  # alias
  # allows for a reference to methods provided by another module and use of those methods within the module in which the statment is being used
  # use
  # for this use statement look at the web.ex file basically calls some macro that imports/alias a bunch of modules
  use Discuss.Web, :controller
  alias Discuss.Topic

  def new(conn, _params) do
    changeset = Topic.changeset(%Topic{}, %{})
    # render accepts a keyword list of arguements that will be passed to the template
    render(conn, "new.html", changeset: changeset)
  end
  # the pattern matching used below is the only way to access keys in a map that are strings instead of atoms
  def create(conn, %{ "topic" => topic }) do
    # Repo.insert returns a tuple with either :ok or :error status and the posted value or invalid changeset respectively
    case Repo.insert(Topic.changeset(%Topic{}, topic)) do
      { :ok, post } -> IO.inspect(post)
      { :error, invalid } -> 
        render(conn, "new.html", changeset: invalid)
    end
  end

  def index(conn, _params) do
    topics = Repo.all(Topic)
    render(conn, "index.html", topics: topics)
  end
end