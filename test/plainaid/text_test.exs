defmodule Plainaid.TextTest do
  use Plainaid.DataCase

  alias Plainaid.Text

  describe "simplify_text" do
    alias Plainaid.Text.Simplifier

    import Plainaid.TextFixtures

    @invalid_attrs %{content: nil}

    test "list_simplify_text/0 returns all simplify_text" do
      simplifier = simplifier_fixture()
      assert Text.list_simplify_text() == [simplifier]
    end

    test "get_simplifier!/1 returns the simplifier with given id" do
      simplifier = simplifier_fixture()
      assert Text.get_simplifier!(simplifier.id) == simplifier
    end

    test "create_simplifier/1 with valid data creates a simplifier" do
      valid_attrs = %{content: "some content"}

      assert {:ok, %Simplifier{} = simplifier} = Text.create_simplifier(valid_attrs)
      assert simplifier.content == "some content"
    end

    test "create_simplifier/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Text.create_simplifier(@invalid_attrs)
    end

    test "update_simplifier/2 with valid data updates the simplifier" do
      simplifier = simplifier_fixture()
      update_attrs = %{content: "some updated content"}

      assert {:ok, %Simplifier{} = simplifier} = Text.update_simplifier(simplifier, update_attrs)
      assert simplifier.content == "some updated content"
    end

    test "update_simplifier/2 with invalid data returns error changeset" do
      simplifier = simplifier_fixture()
      assert {:error, %Ecto.Changeset{}} = Text.update_simplifier(simplifier, @invalid_attrs)
      assert simplifier == Text.get_simplifier!(simplifier.id)
    end

    test "delete_simplifier/1 deletes the simplifier" do
      simplifier = simplifier_fixture()
      assert {:ok, %Simplifier{}} = Text.delete_simplifier(simplifier)
      assert_raise Ecto.NoResultsError, fn -> Text.get_simplifier!(simplifier.id) end
    end

    test "change_simplifier/1 returns a simplifier changeset" do
      simplifier = simplifier_fixture()
      assert %Ecto.Changeset{} = Text.change_simplifier(simplifier)
    end
  end
end
