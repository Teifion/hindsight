defmodule Hindsight.Repo.Migrations.CreateHindsightAnswerLists do
  use Ecto.Migration

  def change do
    create table(:hindsight_answer_lists) do
      add :value, {:array, :string}, null: false
      add :form_id, references(:hindsight_forms, on_delete: :nothing)
      add :question_id, references(:hindsight_questions, on_delete: :nothing)

      timestamps()
    end

    create index(:hindsight_answer_lists, [:form_id])
    create index(:hindsight_answer_lists, [:question_id])
  end
end
