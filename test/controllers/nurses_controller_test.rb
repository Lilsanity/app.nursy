require "test_helper"

class NursesControllerTest < ActionDispatch::IntegrationTest
  setup do
    commune = Commune.create!(name: "Paris", postal_code: "75001", latitude: 48.8566, longitude: 2.3522)
    @nurse = Nurse.create!(first_name: "Marc", last_name: "Dubois", commune: commune, rpps_number: "12345678901")
    user = User.create!(
      first_name: "Jean", last_name: "Dupont", email: "jean@example.com",
      password: "password", phone: "0612345678", commune: "Paris"
    )
    sign_in user
  end

  test "should get index" do
    get nurses_path
    assert_response :success
  end

  test "should get show" do
    get nurse_path(@nurse)
    assert_response :success
  end
end
