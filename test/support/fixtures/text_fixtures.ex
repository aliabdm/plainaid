defmodule Plainaid.TextFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Plainaid.Text` context.
  """

  @doc """
  Generate a simplifier.
  """
  def simplifier_fixture(attrs \\ %{}) do
    {:ok, simplifier} =
      attrs
      |> Enum.into(%{
        content: "some content"
      })
      |> Plainaid.Text.create_simplifier()

    simplifier
  end
end
