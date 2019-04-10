defmodule Hindsight.Core.AnswerList do
  use Ecto.Schema
  import Ecto.Changeset

  schema "hindsight_answer_lists" do
    field :value, {:array, :string}
    field :form_id, :id
    field :question_id, :id

    timestamps()
  end

  @doc false
  def changeset(answer_list, attrs) do
    answer_list
    |> cast(attrs, [:value])
    |> validate_required([:value])
  end
end
