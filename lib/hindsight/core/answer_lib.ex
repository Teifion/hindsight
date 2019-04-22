defmodule Hindsight.Core.AnswerLib do
  use HindsightWeb, :library

  alias Hindsight.Core.Answer
  alias Hindsight.Core.AnswerText
  alias Hindsight.Core.AnswerList
  alias Hindsight.Core.AnswerMap  
  alias Hindsight.Core.QuestionLib
  
  def answer_lookup(nil, _), do: nil
  def answer_lookup(form) do
    form.answers
    ++ form.answer_lists
    ++ form.answer_maps
    ++ form.answer_texts
    |> Enum.map(fn a ->
      {a.question_id, a}
    end)
    |> Map.new
  end
  
  def merge_answers(existing_answers, questions, params) do
    new_answers = questions
    |> Enum.map(fn question ->
      answer = QuestionLib.parse_answer(question, params)
      
      {question.id, %{value: answer}}
    end)
    |> Map.new
    
    Map.merge(existing_answers, new_answers)
  end
  
  def check_for_errors(questions, params) do
    questions
    |> Enum.filter(fn question ->
      question.visible == true
    end)
    |> Enum.map(fn question ->
      answer = QuestionLib.parse_answer(question, params)
      
      {
        question.id,
        [
          required?(question, answer)
        ]
        |> Enum.filter(fn r -> r != nil end)
      }
      
    end)
    |> Enum.filter(fn {_, errors} -> errors != [] end)
  end
  
  defp required?(question, answer) do
    if question.options["required"] == true and QuestionLib.has_answer?(question) do
      if Enum.member?([[], "", nil], answer) do
        "Answer required"
      end
    end
  end

  def save_answers(multi, template, _form_changeset, form_params) do
    multi
    |> Multi.run(:hindsight_answers, fn _repo, %{hindsight_forms: form} ->
      result = Repo.insert_all(Answer,
        template.questions
        |> Enum.filter(&QuestionLib.has_answer?/1)
        |> Enum.filter(&QuestionLib.is_answer_text?/1)
        |> Enum.map(fn q ->
          %{
            form_id: form.id,
            question_id: q.id,
            # value: form_params["q_#{q.id}"],
            value: QuestionLib.parse_answer(q, form_params),
          }
        end),
        on_conflict: :replace_all,
        conflict_target: [:form_id, :question_id]
      )
      
      {:ok, result}
    end)
    |> Multi.run(:hindsight_answer_texts, fn _repo, %{hindsight_forms: form} ->
      result = Repo.insert_all(AnswerText,
        template.questions
        |> Enum.filter(&QuestionLib.has_answer?/1)
        |> Enum.filter(&QuestionLib.is_answer_large_text?/1)
        |> Enum.map(fn q ->
          %{
            form_id: form.id,
            question_id: q.id,
            # value: form_params["q_#{q.id}"],
            value: QuestionLib.parse_answer(q, form_params),
          }
        end),
        on_conflict: :replace_all,
        conflict_target: [:form_id, :question_id]
      )
      
      {:ok, result}
    end)
    |> Multi.run(:hindsight_answer_lists, fn _repo, %{hindsight_forms: form} ->
      result = Repo.insert_all(AnswerList,
        template.questions
        |> Enum.filter(&QuestionLib.has_answer?/1)
        |> Enum.filter(&QuestionLib.is_answer_list?/1)
        |> Enum.map(fn q ->
          %{
            form_id: form.id,
            question_id: q.id,
            value: QuestionLib.parse_answer(q, form_params),
          }
        end),
        on_conflict: :replace_all,
        conflict_target: [:form_id, :question_id]
      )
      
      {:ok, result}
    end)
    |> Multi.run(:hindsight_answer_maps, fn _repo, %{hindsight_forms: form} ->
      result = Repo.insert_all(AnswerMap,
        template.questions
        |> Enum.filter(&QuestionLib.has_answer?/1)
        |> Enum.filter(&QuestionLib.is_answer_map?/1)
        |> Enum.map(fn q ->
          %{
            form_id: form.id,
            question_id: q.id,
            value: %{value: QuestionLib.parse_answer(q, form_params)},
          }
        end),
        on_conflict: :replace_all,
        conflict_target: [:form_id, :question_id]
      )
      
      {:ok, result}
    end)
  end
  
  def prepare_for_broadcast(questions, form) do
    answers = answer_lookup(form)
    
    questions
    |> Enum.map(fn q ->
      a = answers[q.id]
      
      {q.id, %{
        question: q.label,
        answer: (if a != nil, do: a.value, else: nil),
      }}
    end)
    |> Map.new
  end
end