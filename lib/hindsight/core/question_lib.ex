defmodule Hindsight.Core.QuestionLib do
  import Ecto.Query, warn: false
  alias Hindsight.Repo

  alias Hindsight.Core.Question

  @doc false
  @spec get_next_ordering(integer) :: integer
  def get_next_ordering(template_id) do
    query = from questions in Question,
      where: questions.template_id == ^template_id,
      select: max(questions.ordering),
      limit: 1
    
    Repo.one!(query) || 0
  end
  
  @doc false
  def create_from_preset(params) do
    {question_type, options} = case params["question_type"] do
      "Preset: Yes/No" ->
        {
          "Radio buttons",
          %{
            "choices" => [
              %{"label" => "Yes", "points" => "1", "modifier" => "100"},
              %{"label" => "No", "points" => "0", "modifier" => "100"}
            ]
          }
        }
      
      "Preset: Pass/Fail" ->
        {
          "Radio buttons",
          %{
            "choices" => [
              %{"label" => "Pass", "points" => "1", "modifier" => "100"},
              %{"label" => "Fail", "points" => "0", "modifier" => "100"}
            ]
          }
        }
      
      "Preset: Scale 1-5" ->
        {
          "Dropdown",
          %{
            "choices" => [
              %{"label" => "1", "points" => "1", "modifier" => "100"},
              %{"label" => "2", "points" => "2", "modifier" => "100"},
              %{"label" => "3", "points" => "3", "modifier" => "100"},
              %{"label" => "4", "points" => "4", "modifier" => "100"},
              %{"label" => "5", "points" => "5", "modifier" => "100"},
            ]
          }
        }
      
      "Preset: Scale Agreement level" ->
        {
          "Radio buttons",
          %{
            "choices" => [
              %{"label" => "Strongly agree", "points" => "5", "modifier" => "100"},
              %{"label" => "Mostly agree", "points" => "4", "modifier" => "100"},
              %{"label" => "Neither agree or disagree", "points" => "3", "modifier" => "100"},
              %{"label" => "Mostly disagree", "points" => "2", "modifier" => "100"},
              %{"label" => "Strongly disagree", "points" => "1", "modifier" => "100"},
            ]
          }
        }
      
      "Preset: Currency (GBP)" ->
        {
          "Number",
          %{"placeholder" => "£"}
        }
      
      "Preset: Currency (Euro)" ->
        {
          "Number",
          %{"placeholder" => "€"}
        }
      
      "Preset: Currency (Dollar)" ->
        {
          "Number",
          %{"placeholder" => "$"}
        }
        
      x -> raise "No preset of type '#{x}'"  
    end
    
    Map.merge(params, %{
      "options" => options,
      "question_type" => question_type,
    })
  end
end