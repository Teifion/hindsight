defmodule Hindsight.Repo.Migrations.CreateHindsightForms do
  use Ecto.Migration

  def change do
    create table(:hindsight_forms) do
      add :reference, :string
      add :completed, :boolean, default: false, null: false
      add :completed_at, :naive_datetime
      add :score, :integer
      add :template_id, references(:hindsight_templates, on_delete: :nothing)

      timestamps()
    end

    create index(:hindsight_forms, [:template_id])
  end
end
