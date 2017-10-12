defmodule Discuss.AuthController do
  use Discuss.Web, :controller
  plug Ueberauth
  
  alias Discuss.User
  # defp denotes a private function that will not be exposed whe module is imported externally
  defp find_or_insert_user(changeset) do
    case Repo.get_by(User, email: changeset.changes.email) do
      nil ->
        Repo.insert(changeset)
      user ->
        { :ok, user } # this value is returned because it matches the pattern returned by Repo.insert so return value is consistent
    end
  end

  defp signin(status, conn) do
    case status do
      { :ok, user } ->
        conn
        |> put_flash(:info, "Welcome back!")
        |> put_session(:user_id, user.id)
        |> redirect(to: topic_path(conn, :index))
      { :error, _reason } ->
        conn
        |> put_flash(:error, "Error signing in")
        |> redirect(to: topic_path(conn, :index))
    end
  end
  
  def callback(%{ assigns: %{ ueberauth_auth: auth } } = conn, %{ "provider" => provider }) do
    user_params = %{ 
      token: auth.credentials.token,
      email: auth.info.email,
      provider: provider
    }
    User.changeset(%User{}, user_params)
    |> find_or_insert_user
    |> signin(conn)
  end
end