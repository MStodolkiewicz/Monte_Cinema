require "application_system_test_case"

class HallsTest < ApplicationSystemTestCase
  setup do
    @hall = halls(:one)
  end

  test "visiting the index" do
    visit halls_url
    assert_selector "h1", text: "Halls"
  end

  test "should create hall" do
    visit halls_url
    click_on "New hall"

    fill_in "Capacity", with: @hall.capacity
    fill_in "Number", with: @hall.number
    click_on "Create Hall"

    assert_text "Hall was successfully created"
    click_on "Back"
  end

  test "should update Hall" do
    visit hall_url(@hall)
    click_on "Edit this hall", match: :first

    fill_in "Capacity", with: @hall.capacity
    fill_in "Number", with: @hall.number
    click_on "Update Hall"

    assert_text "Hall was successfully updated"
    click_on "Back"
  end

  test "should destroy Hall" do
    visit hall_url(@hall)
    click_on "Destroy this hall", match: :first

    assert_text "Hall was successfully destroyed"
  end
end
