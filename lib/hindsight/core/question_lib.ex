defmodule Hindsight.Core.QuestionLib do
  @moduledoc false
  
  
  use HindsightWeb, :library
  
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
  
  def has_score?(the_question) do
    Enum.member?([
      "Dropdown", "Check boxes", "Radio buttons"
      ],
      the_question.question_type
    )
  end
  
  def score_question(question, answer) do
    # It is possible nothing was chosen but
    # it is also possible more than one thing was sent
    possible_chosen = if is_list(answer) do
      question.options["choices"]
      |> Enum.filter(fn c -> Enum.member?(answer, c["label"]) end)
    else
      question.options["choices"]
      |> Enum.filter(fn c -> c["label"] == answer end)
    end
    
    choice = if possible_chosen == [] do
      %{"points" => "0", "modifier" => "100"}
    else
      possible_chosen
      |> hd
    end
    
    [choice["points"] |> String.to_integer, choice["modifier"] |> String.to_integer]
  end
  
  def has_answer?(the_question) do
    Enum.member?(
      ["Small text", "Large text", "Rich text",
        "Radio buttons", "Check boxes",
        "Number", "Dropdown", "Two tier dropdown",
        "Date", "Datetime", "Colour",
        "List builder", "Object list",
        
        "System link: Bedrock Customer",
        "System link: Bedrock Employee",
        "System link: Bedrock Policy",
        "System link: Agency Payment",
        "System link: User"
      ],
      the_question.question_type
    )
  end
  
  def is_answer_large_text?(the_question) do
    Enum.member?(
      ["Large text", "Rich text"],
      the_question.question_type
    )
  end
  
  def is_answer_text?(the_question) do
    Enum.member?(
      ["Small text",
        "Radio buttons",
        "Number", "Dropdown", "Two tier dropdown",
        "Date", "Datetime", "Colour",
        
        "System link: Bedrock Customer",
        "System link: Bedrock Employee",
        "System link: Bedrock Policy",
        "System link: Agency Payment",
        "System link: User"
      ],
      the_question.question_type
    )
  end
  
  def is_answer_list?(the_question) do
    Enum.member?(
      ["Check boxes", "List builder"],
      the_question.question_type
    )
  end
  
  def is_answer_map?(the_question) do
    Enum.member?(
      ["Object list"],
      the_question.question_type
    )
  end
  
  @doc false
  def parse_answer(the_question, params) do
    case the_question.question_type do
      "Check boxes" ->
        the_question.options["choices"]
        |> Enum.with_index
        |> Enum.map(fn {_op, i} ->
          params["q_#{the_question.id}_#{i}"]
        end)
        |> Enum.filter(fn v ->
          v != nil
        end)
        
      "Object list" ->
        # We use numbers on the HTML to store which field we are
        # dealing with as we can't rely on the fields
        # to have a valid and unique ID value
        choices = the_question.options["choices"]
        |> Enum.with_index
        |> Enum.map(fn {c, i} -> {"#{i}", c} end)
        |> Map.new
        
        if params["q_#{the_question.id}"] do
          params["q_#{the_question.id}"]
          |> Enum.map(fn {_row, values} ->
            values
            |> Enum.map(fn {k, v} ->
              {choices[k]["label"], v}
            end)
            |> Map.new
          end)
        else
          []
        end
        
      _ -> 
        params["q_#{the_question.id}"]
    end
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