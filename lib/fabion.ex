defmodule Fabion do

  @moduledoc """
  Fabion keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def schema do
    quote do
      use Fabion.BaseSchema
    end
  end

  @doc """
  When used, dispatch to the appropriate schema/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
