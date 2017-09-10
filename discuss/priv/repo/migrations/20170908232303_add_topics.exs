defmodule Discuss.Repo.Migrations.AddTopics do
  use Ecto.Migration
  # this migration gets created by running mix ecto.gen.migration add_topics (the last argument dictates is dynamic)
  # inside the change function the create function is defined to generate the table within postgres with the table name being the argument for the table function
  # execute migration by calling mix ecto.migrate
  def change do
    create table(:topics) do
      add :title, :string
    end
  end
end
