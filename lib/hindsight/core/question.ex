defmodule Hindsight.Core.Question do
  use Ecto.Schema
  import Ecto.Changeset

  schema "hindsight_questions" do
    field :description, :string
    field :label, :string
    field :options, :map
    field :ordering, :integer
    field :question_type, :string
    field :visible, :boolean, default: true
    
    belongs_to :template, Hindsight.Core.Template

    timestamps()
  end

  @doc false
  def changeset(question, attrs) do
    question
    |> cast(attrs, [:label, :description, :visible, :options, :ordering, :question_type, :template_id])
    |> validate_required([:question_type, :label, :visible, :options, :ordering, :template_id])
  end
  
  @spec question_types() :: [String.t()]
  def question_types() do
    [
      "Header",
      "HTML",
      "Small text",
      "Large text",
      "Rich text",
      "Radio buttons",
      "Check boxes",
      "Number",
      "Dropdown",
      "List builder",
      "Object list",
      "Colour",
      "Date",
      # "Datetime",
    ]
  end
  
  @spec question_types(atom) :: [String.t()]
  def question_types(:with_presets) do
    question_types()
    ++ [
      "Preset: Yes/No",
      "Preset: Pass/Fail",
      "Preset: Scale 1-5",
      "Preset: Scale Agreement level",
      
      "Preset: Currency (GBP)",
      "Preset: Currency (Euro)",
      "Preset: Currency (Dollar)",
    ]
  end
  
  @spec field_types() :: [String.t()]
  def field_types() do
    [
      "Text",
      "Number",
      "Dropdown",
      "Date",
    ]
  end
end
