defmodule Hindsight.Repo.Migrations.CreateHindsightAnswerMaps do
  use Ecto.Migration

  def change do
    create table(:hindsight_answer_maps) do
      add :value, :map
      add :form_id, references(:hindsight_forms, on_delete: :nothing)
      add :question_id, references(:hindsight_questions, on_delete: :nothing)

      timestamps()
    end

    create index(:hindsight_answer_maps, [:form_id])
    create index(:hindsight_answer_maps, [:question_id])
  end
end
