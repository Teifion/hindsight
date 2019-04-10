defmodule Hindsight.Core.Form do
  use Ecto.Schema
  import Ecto.Changeset

  schema "hindsight_forms" do
    field :completed, :boolean, default: false
    field :completed_at, :naive_datetime
    field :reference, :string
    field :score, :integer
    field :template_id, :id

    timestamps()
  end

  @doc false
  def changeset(form, attrs) do
    form
    |> cast(attrs, [:reference, :completed, :completed_at, :score])
    |> validate_required([:reference, :completed, :completed_at, :score])
  end
end
