defmodule Hindsight.Core.AnswerList do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "hindsight_answer_lists" do
    field :value, {:array, :string}
    belongs_to :form, Hindsight.Core.Form, primary_key: true
    belongs_to :question, Hindsight.Core.Question, primary_key: true
  end

  @doc false
  def changeset(answer_list, attrs) do
    answer_list
    |> cast(attrs, [:value, :form_id, :question_id])
    |> validate_required([:value, :form_id, :question_id])
  end
end
