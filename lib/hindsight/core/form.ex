defmodule Hindsight.Core.Form do
  use Ecto.Schema
  import Ecto.Changeset

  schema "hindsight_forms" do
    field :completed, :boolean, default: false
    field :completed_at, :naive_datetime
    field :reference, :string
    field :score, :integer
    belongs_to :template, Hindsight.Core.Template

    timestamps()
  end

  @doc false
  def changeset(form, attrs) do
    form
    |> cast(attrs, [:reference, :completed, :completed_at, :score, :template_id])
    |> validate_required([:reference, :completed, :template_id])
  end
end
