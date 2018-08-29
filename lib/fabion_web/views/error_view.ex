defmodule FabionWeb.ErrorView do
  use FabionWeb, :view

  # If you want to customize a particular status code
  # for a certain format, you may uncomment below.
  # def render("500.json", _assigns) do
  #   %{errors: %{detail: "Internal Server Error"}}
  # end
  # def render("500.html", _assigns) do
  #   "Internal Server Error"
  # end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.html" becomes
  # the template name. For example, "404.json" becomes
  # "Not Found".
  def template_not_found(template, _assigns) do
    cond do
      template =~ ~r/^.*\.json$/ ->
        %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
      true ->
        Phoenix.Controller.status_message_from_template(template)
    end
  end
end
