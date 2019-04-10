defmodule Hindsight.Repo.Migrations.CreateTemplates do
  use Ecto.Migration

  def change do
    create table(:templates) do
      add :name, :string, null: false
      add :description, :string
      add :options, :map
      add :colour, :string
      add :icon, :string
      add :enabled, :boolean, default: true, null: false
      add :use_score, :boolean, default: false, null: false
      add :max_score, :integer

      timestamps()
    end

  end
end
