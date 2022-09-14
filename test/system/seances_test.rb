require "application_system_test_case"

class SeancesTest < ApplicationSystemTestCase
  setup do
    @seance = seances(:one)
  end

  test "visiting the index" do
    visit seances_url
    assert_selector "h1", text: "Seances"
  end

  test "should create seance" do
    visit seances_url
    click_on "New seance"

    fill_in "End time", with: @seance.end_time
    fill_in "Hall", with: @seance.hall_id
    fill_in "Movie", with: @seance.movie_id
    fill_in "Price", with: @seance.price
    fill_in "Start time", with: @seance.start_time
    click_on "Create Seance"

    assert_text "Seance was successfully created"
    click_on "Back"
  end

  test "should update Seance" do
    visit seance_url(@seance)
    click_on "Edit this seance", match: :first

    fill_in "End time", with: @seance.end_time
    fill_in "Hall", with: @seance.hall_id
    fill_in "Movie", with: @seance.movie_id
    fill_in "Price", with: @seance.price
    fill_in "Start time", with: @seance.start_time
    click_on "Update Seance"

    assert_text "Seance was successfully updated"
    click_on "Back"
  end

  test "should destroy Seance" do
    visit seance_url(@seance)
    click_on "Destroy this seance", match: :first

    assert_text "Seance was successfully destroyed"
  end
end
