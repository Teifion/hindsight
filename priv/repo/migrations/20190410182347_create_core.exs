defmodule Hindsight.Repo.Migrations.CreateTemplates do
  use Ecto.Migration

  def change do
    create table(:hindsight_templates) do
      add :name, :string, null: false
      add :description, :string
      add :options, :jsonb
      add :colour, :string
      add :icon, :string
      add :enabled, :boolean, default: true, null: false
      add :use_score, :boolean, default: false, null: false
      add :max_score, :integer

      timestamps()
    end
  
    create table(:hindsight_questions) do
      add :label, :string, null: false
      add :description, :string
      add :visible, :boolean, default: false, null: false
      add :options, :jsonb
      add :ordering, :integer, null: false
      add :question_type, :string, null: false
      add :template_id, references(:hindsight_templates, on_delete: :nothing)

      timestamps()
    end

    create index(:hindsight_questions, [:template_id])

    
    create table(:hindsight_forms) do
      add :reference, :string, null: false
      add :completed, :boolean, default: false, null: false
      add :completed_at, :naive_datetime
      add :score, :integer
      add :template_id, references(:hindsight_templates, on_delete: :nothing)
      
      timestamps()
    end

    create index(:hindsight_forms, [:template_id])
    create index(:hindsight_forms, [:reference])
    
    
    create table(:hindsight_answers, primary_key: false) do
      add :form_id, references(:hindsight_forms, on_delete: :nothing), primary_key: true
      add :question_id, references(:hindsight_questions, on_delete: :nothing), primary_key: true
      
      add :value, :string
    end
    create index(:hindsight_answers, [:form_id])
    create index(:hindsight_answers, [:question_id])
    
    create table(:hindsight_answer_lists, primary_key: false) do
      add :form_id, references(:hindsight_forms, on_delete: :nothing), primary_key: true
      add :question_id, references(:hindsight_questions, on_delete: :nothing), primary_key: true
      
      add :value, {:array, :string}
    end
    create index(:hindsight_answer_lists, [:form_id])
    create index(:hindsight_answer_lists, [:question_id])
    
    create table(:hindsight_answer_maps, primary_key: false) do
      add :form_id, references(:hindsight_forms, on_delete: :nothing), primary_key: true
      add :question_id, references(:hindsight_questions, on_delete: :nothing), primary_key: true
      
      add :value, :jsonb
    end
    create index(:hindsight_answer_maps, [:form_id])
    create index(:hindsight_answer_maps, [:question_id])
    
    create table(:hindsight_answer_texts, primary_key: false) do
      add :form_id, references(:hindsight_forms, on_delete: :nothing), primary_key: true
      add :question_id, references(:hindsight_questions, on_delete: :nothing), primary_key: true
      
      add :value, :text
    end
    create index(:hindsight_answer_texts, [:form_id])
    create index(:hindsight_answer_texts, [:question_id])
  end
end
