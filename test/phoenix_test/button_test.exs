defmodule PhoenixTest.ButtonTest do
  use ExUnit.Case, async: true

  alias PhoenixTest.Button

  describe "find!" do
    test "finds button by selector and text" do
      html = """
      <button id="save">
        Save
      </button>

      <button id="delete">
        Delete
      </button>
      """

      button = Button.find!(html, "button", "Save")

      assert button.id == "save"
    end

    test "raises an error if no button is found" do
      html = """
      <button id="save">
        Save
      </button>
      """

      assert_raise ArgumentError, fn ->
        Button.find!(html, "button", "Delete")
      end
    end
  end

  describe "button.selector" do
    test "returns a dom id if an id is found" do
      html = """
      <button id="save">
        Save
      </button>
      """

      button = Button.find!(html, "button", "Save")

      assert button.selector == "#save"
    end

    test "returns a composite selector if button has no id" do
      html = """
      <button name="super" value="button">
        Save
      </button>
      """

      button = Button.find!(html, "button", "Save")

      assert button.selector == ~s(button[name="super"][value="button"])
    end
  end

  describe "button.raw" do
    test "returns the button's HTML" do
      html = """
      <form>
        <button>
          Save
        </button>
      </form>
      """

      button = Button.find!(html, "button", "Save")

      button_html = """
      <button>
        Save
      </button>
      """

      assert button.raw == button_html
    end
  end

  describe "button.source_raw" do
    test "returns the original HTML from which the button was found" do
      html = """
      <form>
        <button>
          Save
        </button>
      </form>
      """

      button = Button.find!(html, "button", "Save")

      assert button.source_raw == html
    end
  end

  describe "button.name and button.value" do
    test "returns button's name and value if present" do
      html = """
      <button name="super" value="save">
        Save
      </button>
      """

      button = Button.find!(html, "button", "Save")

      assert button.name == "super"
      assert button.value == "save"
    end

    test "returns nil if name and value aren't found" do
      html = """
      <button>
        Save
      </button>
      """

      button = Button.find!(html, "button", "Save")

      assert is_nil(button.name)
      assert is_nil(button.value)
    end
  end

  describe "belongs_to_form?" do
    test "returns true if button has a form ancestor" do
      html = """
      <form>
        <button>
          Save
        </button>
      </form>
      """

      button = Button.find!(html, "button", "Save")

      assert Button.belongs_to_form?(button)
    end

    test "returns false if button stands alone" do
      html = """
      <button>
        Save
      </button>
      """

      button = Button.find!(html, "button", "Save")

      refute Button.belongs_to_form?(button)
    end
  end

  describe "phx_click?" do
    test "returns true if button has a phx-click attribute" do
      html = """
      <button phx-click="save">
        Save
      </button>
      """

      button = Button.find!(html, "button", "Save")

      assert Button.phx_click?(button)
    end

    test "returns false if button doesn't have a phx-click attribute" do
      html = """
      <button>
        Save
      </button>
      """

      button = Button.find!(html, "button", "Save")

      refute Button.phx_click?(button)
    end
  end

  describe "has_data_method?" do
    test "returns true if button has a data-method attribute" do
      html = """
      <button data-method="put">
        Save
      </button>
      """

      button = Button.find!(html, "button", "Save")

      assert Button.has_data_method?(button)
    end

    test "returns false if button doesn't have a data-method attribute" do
      html = """
      <button>
        Save
      </button>
      """

      button = Button.find!(html, "button", "Save")

      refute Button.has_data_method?(button)
    end
  end

  describe "parent_form!" do
    test "returns the ancestor form when button was found" do
      html = """
      <form id="form">
        <button>
          Save
        </button>
      </form>
      """

      form =
        html
        |> Button.find!("button", "Save")
        |> Button.parent_form!()

      assert form.id == "form"
    end

    test "raises an error if no parent form is found" do
      html = """
        <button>
          Save
        </button>
      """

      button =
        Button.find!(html, "button", "Save")

      assert_raise ArgumentError, fn ->
        Button.parent_form!(button)
      end
    end
  end
end
