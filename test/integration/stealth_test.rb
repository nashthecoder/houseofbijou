require "test_helper"

class StealthTest < ActionDispatch::IntegrationTest
  setup do
    @setting = Setting.create!(pin: "2500", values_accepted_at: Time.current, pseudonym: "Tester")
  end

  test "weather is the default disguise on mobile" do
    @setting.update!(disguise: "Weather")

    get root_path
    assert_response :success
    assert_match "Current temperature", response.body
    assert_no_match "Panic alert", response.body
  end

  test "calculator skin still available as a disguise option" do
    @setting.update!(disguise: "Calculator")

    get root_path
    assert_response :success
    assert_match "Calculator display", response.body
    assert_no_match "Panic alert", response.body
  end

  test "tile game and sports skins render as decoys" do
    @setting.update!(disguise: "Tile game")
    get root_path
    assert_response :success
    assert_match "Tile match", response.body
    assert_no_match "Panic alert", response.body

    @setting.update!(disguise: "Sports")
    get root_path
    assert_response :success
    assert_match "Match scores", response.body
    assert_no_match "Panic alert", response.body
  end

  test "real app is locked until unlocked" do
    get dashboard_path
    assert_redirected_to root_path
  end

  test "unlock with correct code opens the app" do
    post unlock_path, params: { code: "2500" }, as: :json
    assert_response :success
    assert_equal({ "status" => "ok" }, JSON.parse(response.body))

    get dashboard_path
    assert_response :success
    assert_match "among friends", response.body
  end

  test "unlock with wrong code is denied and stays disguised" do
    post unlock_path, params: { code: "9999" }, as: :json
    assert_response :unauthorized

    get dashboard_path
    assert_redirected_to root_path
  end

  test "first-time users pass the values agreement gate before the dashboard" do
    @setting.update!(values_accepted_at: nil, pseudonym: nil)

    post unlock_path, params: { code: "2500" }, as: :json
    assert_equal({ "status" => "values" }, JSON.parse(response.body))

    get dashboard_path
    assert_redirected_to values_path

    get values_path
    assert_response :success
    assert_match "Our values agreement", response.body

    post values_path
    assert_redirected_to onboarding_path

    get dashboard_path
    assert_redirected_to onboarding_path

    post onboarding_path, params: { setting: { pseudonym: "Zawadi", avatar_color: "#a9bd7e" } }
    assert_redirected_to dashboard_path

    get dashboard_path
    assert_response :success
  end

  test "unlock routes to onboarding when identity is not set up yet" do
    @setting.update!(pseudonym: nil)

    post unlock_path, params: { code: "2500" }, as: :json
    assert_equal({ "status" => "onboarding" }, JSON.parse(response.body))

    get onboarding_path
    assert_response :success
    assert_match "Who will your circle see?", response.body

    post onboarding_path, params: { setting: { pseudonym: "" } }
    assert_response :unprocessable_entity

    post onboarding_path, params: { setting: { pseudonym: "Zawadi" } }
    assert_redirected_to dashboard_path
  end

  test "hide button relocks immediately" do
    post unlock_path, params: { code: "2500" }, as: :json
    get dashboard_path
    assert_response :success

    post hide_path
    assert_redirected_to root_path

    get dashboard_path
    assert_redirected_to root_path
  end

  test "idle session relocks after 24 hours" do
    travel_to Time.current do
      post unlock_path, params: { code: "2500" }, as: :json
      get dashboard_path
      assert_response :success
    end

    travel 25.hours do
      get dashboard_path
      assert_redirected_to root_path
    end
  end
end
