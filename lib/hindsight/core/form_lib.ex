defmodule Hindsight.Core.FormLib do
  use HindsightWeb, :library
  
  alias Hindsight.Core.QuestionLib
  alias Hindsight.Core.AnswerLib
  
  def insert_form_answers(form_changeset, form_params, template) do
    multi = Multi.new
    |> Multi.insert(:hindsight_forms, form_changeset)
    |> AnswerLib.save_answers(template, form_changeset, form_params)
    
    {:ok, result} = Repo.transaction(multi)
    
    result
  end
  
  def update_form_answers(form_changeset, form_params, template) do
    multi = Multi.new
    |> Multi.update(:hindsight_forms, form_changeset)
    |> AnswerLib.save_answers(template, form_changeset, form_params)
    
    {:ok, result} = Repo.transaction(multi)
    
    result
  end
  
  def score(template, form_params) do
    if template.use_score do
      [points, modifier] = template.questions
      |> Enum.filter(fn q ->
        QuestionLib.has_score?(q)
      end)
      |> Enum.map(fn q ->
        ans = QuestionLib.parse_answer(q, form_params)
        
        QuestionLib.score_question(q, ans)
      end)
      |> Enum.reduce([0, 1], fn ([pts, mod], [acc_pts, acc_mod]) ->
        [acc_pts + pts, acc_mod * (mod/100)]
      end)
      
      max_score = if template.max_score, do: max(template.max_score,1), else: 1
      
      (points * modifier * 100) / max_score
      |> round
      |> max(0)
      |> min(100)
    end
  end
  
  def explain_scoring(template, form) do
    answers = form.answers
    ++ form.answer_texts
    ++ form.answer_lists
    ++ form.answer_maps
    
    questions = template.questions
    |> Enum.map(fn q -> {q.id, q} end)
    |> Map.new
    
    answers
    |> Enum.map(fn a -> {questions[a.question_id], a} end)
    |> Enum.filter(fn {q, _a} -> QuestionLib.has_score?(q) end)
    |> Enum.map_reduce({0, 1}, fn ({q, a}, {pts, mod}) ->
      [apoints, amodifier] = QuestionLib.score_question(q, a.value)
      
      new_pts = pts + apoints
      new_mod = mod * (amodifier/100)
      
      row = %{
        label: q.label,
        points: apoints,
        modifier: amodifier,
        
        tmp_points: new_pts,
        tmp_modifier: new_mod,
      }
      
      {row, {new_pts, new_mod}}
    end)
  end
  
  def create_guid do
    32
    |> :crypto.strong_rand_bytes()
    |> Base.url_encode64(padding: false)
  end
end