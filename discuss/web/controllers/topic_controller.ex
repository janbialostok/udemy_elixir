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

  def new(conn, params) do
    changeset = Topic.changeset(%Topic{}, %{})
    # render accepts a keyword list of arguements that will be passed to the template
    render(conn, "new.html", changeset: changeset)
  end
  # the pattern matching used below is the only way to access keys in a map that are strings instead of atoms
  def create(conn, %{ "topic" => topic }) do

  end
end