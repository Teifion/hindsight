defmodule Hindsight.Core.AnswerMap do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "hindsight_answer_maps" do
    field :value, :map
    belongs_to :form, Hindsight.Core.Form, primary_key: true
    belongs_to :question, Hindsight.Core.Question, primary_key: true
  end

  @doc false
  def changeset(answer_map, attrs) do
    answer_map
    |> cast(attrs, [:value, :form_id, :question_id])
    |> validate_required([:value, :form_id, :question_id])
  end
end
