defmodule Hindsight.Repo.Migrations.CreateHindsightAnswers do
  use Ecto.Migration

  def change do
    create table(:hindsight_answers) do
      add :value, :string
      add :form_id, references(:hindsight_forms, on_delete: :nothing)
      add :question_id, references(:hindsight_questions, on_delete: :nothing)

      timestamps()
    end

    create index(:hindsight_answers, [:form_id])
    create index(:hindsight_answers, [:question_id])
  end
end
