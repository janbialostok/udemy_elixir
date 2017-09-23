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
      { :ok, _topic } ->
        # put_flash method is exposed by the :controller and flashes a message of redirect similar to req.flash in express
        put_flash(conn, :info, "Topic Created")
        |> redirect(to: topic_path(conn, :index)) # redirect method also exposed by :controller accepts conn and a argument with to: as a property which expects the topic_path method to be called with connection and routher path atom
      { :error, invalid } -> 
        render(conn, "new.html", changeset: invalid)
    end
  end

  def index(conn, _params) do
    topics = Repo.all(Topic)
    render(conn, "index.html", topics: topics)
  end
  
  def edit(conn, %{ "id" => topic_id }) do
    topic = Repo.get(Topic, topic_id)
    changeset = Topic.changeset(topic)
    render(conn, "edit.html", changeset: changeset, topic: topic)
  end

  def update(conn, %{ "topic" => topic, "id" => topic_id }) do
    original = Repo.get(Topic, topic_id)
    changeset = Topic.changeset(original, topic)
    case Repo.update(changeset) do
      { :ok, _topic } ->
        put_flash(conn, :info, "Topic Updated")
        |> redirect(to: topic_path(conn, :index))
      { :error, invalid } -> 
        render(conn, "edit.html", changeset: invalid, topic: original)
    end
  end

  def delete(conn, %{ "id" => topic_id }) do
    # delete! (almost all the crud operations have ! methods) will specifically redirect the user to an error page vs delete which lets you explicitly specify error behaviour
    Repo.get!(Topic, topic_id)
    |> Repo.delete!
    put_flash(conn, :info, "Topic Deleted")
    |> redirect(to: topic_path(conn, :index))
  end
end