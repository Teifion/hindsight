defmodule HindsightWeb.Router do
  use HindsightWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", HindsightWeb, as: :hindsight do
    pipe_through :browser

    get "/", PageController, :index
    
    resources "/templates", TemplateController, only: [:index, :create, :edit, :delete, :update, :new]
    resources "/forms", FormController
    resources "/questions", QuestionController, only: [:create, :edit, :update, :delete]
  end

  # Other scopes may use custom stacks.
  # scope "/api", HindsightWeb do
  #   pipe_through :api
  # end
end
