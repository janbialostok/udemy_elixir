defmodule Discuss.Plugs.RequireAuth do
  import Plug.Conn
  import Phoenix.Controller

  alias Discuss.Router.Helpers
  # init and call must be defined for each plug init is called once when the module is required and call is called each time the module is used
  def init(_params) do
    
  end
  # params for the call method is what is returned from the init function
  def call(conn, _params) do
    if conn.assigns[:user] do
      conn # all you have to do here is return the conn
    else
      conn
      |> put_flash(:error, "You must be logged in.")
      |> redirect(to: Helpers.topic_path(conn, :index))
      |> halt() # the halt method is used here because plugs must be default to not end a request process and so you must signify that the process should stop here
    end
  end
end
