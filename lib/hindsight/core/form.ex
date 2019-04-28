defmodule Hindsight.Core.Form do
  use Ecto.Schema
  import Ecto.Changeset

  schema "hindsight_forms" do
    field :completed, :boolean, default: false
    field :completed_at, :naive_datetime
    field :reference, :string
    field :score, :integer
    belongs_to :template, Hindsight.Core.Template

    has_many :answers, Hindsight.Core.Answer
    has_many :answer_lists, Hindsight.Core.AnswerList
    has_many :answer_maps, Hindsight.Core.AnswerMap
    has_many :answer_texts, Hindsight.Core.AnswerText

    timestamps()
  end

  @doc false
  def changeset(form, attrs) do
    form
    |> cast(attrs, [:reference, :completed, :completed_at, :score, :template_id])
    |> validate_required([:reference, :completed, :template_id])
  end
end
