defmodule Hindsight.Core.Question do
  use Ecto.Schema
  import Ecto.Changeset

  schema "hindsight_questions" do
    field :description, :string
    field :label, :string
    field :options, :map
    field :ordering, :integer
    field :question_type, :string
    field :visible, :boolean, default: false
    field :template_id, :id

    timestamps()
  end

  @doc false
  def changeset(question, attrs) do
    question
    |> cast(attrs, [:label, :description, :visible, :options, :ordering, :question_type])
    |> validate_required([:label, :description, :visible, :options, :ordering, :question_type])
  end
end
