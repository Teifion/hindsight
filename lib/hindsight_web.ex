defmodule HindsightWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use HindsightWeb, :controller
      use HindsightWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def controller do
    quote do
      use Phoenix.Controller, namespace: HindsightWeb

      import Plug.Conn
      import HindsightWeb.Gettext
      alias HindsightWeb.Router.Helpers, as: Routes
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/hindsight_web/templates",
        namespace: HindsightWeb

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_csrf_token: 0, get_flash: 1, get_flash: 2, view_module: 1]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      import Hindsight.Helpers.StringHelper
      import Hindsight.Helpers.InputHelper
      import Hindsight.Helpers.ComponentHelper
      import Hindsight.Helpers.TimexHelper

      import HindsightWeb.ErrorHelpers
      import HindsightWeb.Gettext
      alias HindsightWeb.Router.Helpers, as: Routes
    end
  end
  
  def library do
    quote do
      alias Hindsight.Repo
      # import Ecto
      import Ecto.Query, warn: false
      alias Ecto.Multi
    end
  end

  def router do
    quote do
      use Phoenix.Router
      import Plug.Conn
      import Phoenix.Controller
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import HindsightWeb.Gettext
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
