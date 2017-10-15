defmodule Discuss.Plugs.SetUser do
  import Plug.Conn
  import Phoenix.Controller

  alias Discuss.Repo
  alias Discuss.User
  alias Discuss.Router.Helpers

  def init(_params) do
  
  end

  def call(conn, _params) do
    # get_session method pulls a value defined by the second value atom from the session stored on the conn object
    user_id = get_session(conn, :user_id)
    # cond statements look at all evaluations and execute the first one that returns true
    cond do
      # in elixir if a boolean expression is defined on a var the final truthy value is stored as on the var
      user = user_id && Repo.get(User, user_id) ->
        # convenience method for assigning a value to the assigns property on the conn object and returning updated conn
        assign(conn, :user, user)
      # true values are often used as a default in cond statements
      true ->
        assign(conn, :user, nil)
    end
  end
end