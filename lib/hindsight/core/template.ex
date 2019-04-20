defmodule Hindsight.Core.Template do
  use Ecto.Schema
  import Ecto.Changeset

  schema "hindsight_templates" do
    field :colour, :string
    field :description, :string
    field :enabled, :boolean, default: false
    field :icon, :string
    field :max_score, :integer
    field :name, :string
    field :options, :map
    field :use_score, :boolean, default: false
    
    has_many :questions, Hindsight.Core.Question

    timestamps()
  end

  @doc false
  def changeset(template, attrs) do
    template
    |> cast(attrs, [:name, :description, :options, :colour, :icon, :enabled, :use_score, :max_score])
    |> validate_required([:name, :options, :colour, :icon, :enabled, :use_score])
  end
end
