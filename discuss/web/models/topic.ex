defmodule Discuss.Topic do
  use Discuss.Web, :model

  schema "topics" do
    field :title, :string
  end
  # \\ %{} is a way express default arguments in elixir. In this case if nil is passed for the params argument it will be set to %{}
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title]) # cast function produces a changeset from the struct representing the value in the database, the params that represent the new values
    |> validate_required([:title]) # runs validations on the changeset produced from cast
  end
end

# iex> struct = %Discuss.Topic{}
# iex> params = %{ title: "GreatJS" }
# iex> Discuss.Topic.changeset(struct, params)
# #Ecto.Changeset<action: nil, changes: %{title: "GreatJS"}, errors: [], data: #Discuss.Topic<>, valid?: true>
# the returned changeset is what is actually saved in the database