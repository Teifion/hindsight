defmodule Hindsight.Repo.Migrations.CreateHindsightAnswerTexts do
  use Ecto.Migration

  def change do
    create table(:hindsight_answer_texts) do
      add :value, :text
      add :form_id, references(:hindsight_forms, on_delete: :nothing)
      add :question_id, references(:hindsight_questions, on_delete: :nothing)

      timestamps()
    end

    create index(:hindsight_answer_texts, [:form_id])
    create index(:hindsight_answer_texts, [:question_id])
  end
end
