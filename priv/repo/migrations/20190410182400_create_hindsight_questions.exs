defmodule Hindsight.Repo.Migrations.CreateHindsightQuestions do
  use Ecto.Migration

  def change do
    create table(:hindsight_questions) do
      add :label, :string
      add :description, :string
      add :visible, :boolean, default: false, null: false
      add :options, :map
      add :ordering, :integer
      add :question_type, :string
      add :template_id, references(:hindsight_templates, on_delete: :nothing)

      timestamps()
    end

    create index(:hindsight_questions, [:template_id])
  end
end
