defmodule Hindsight.Core.Answer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "hindsight_answers" do
    field :value, :string
    field :form_id, :id
    field :question_id, :id

    timestamps()
  end

  @doc false
  def changeset(answer, attrs) do
    answer
    |> cast(attrs, [:value])
    |> validate_required([:value])
  end
end
