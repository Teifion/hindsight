defmodule Hindsight.Core.AnswerMap do
  use Ecto.Schema
  import Ecto.Changeset

  schema "hindsight_answer_maps" do
    field :value, :map
    field :form_id, :id
    field :question_id, :id

    timestamps()
  end

  @doc false
  def changeset(answer_map, attrs) do
    answer_map
    |> cast(attrs, [:value])
    |> validate_required([:value])
  end
end
