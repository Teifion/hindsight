defmodule Hindsight.Core.AnswerText do
  use Ecto.Schema
  import Ecto.Changeset

  schema "hindsight_answer_texts" do
    field :value, :string
    field :form_id, :id
    field :question_id, :id

    timestamps()
  end

  @doc false
  def changeset(answer_text, attrs) do
    answer_text
    |> cast(attrs, [:value])
    |> validate_required([:value])
  end
end
