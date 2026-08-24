require "test_helper"

class CoordinatorDashboardTest < ActionDispatch::IntegrationTest
  setup do
    @setting = Setting.create!(pin: "2500", values_accepted_at: Time.current, pseudonym: "Tester")
    post unlock_path, params: { code: "2500" }, as: :json
  end

  test "coordinator view renders as a desktop page outside the phone frame" do
    AidRequest.create!(title: "Clinic fee", target_amount: 1_000, deadline: 5.days.from_now, status: "open")
    get coordinator_path

    assert_response :success
    assert_match "Holding the community", response.body
    refute_match 'class="mobile-frame"', response.body
    assert_match "max-w-6xl", response.body
    assert_match "Alert follow-up queue", response.body
    assert_match "Back to the app", response.body
  end

  test "alert queue lists panic alerts and review clears them" do
    Contact.create!(name: "Mumbi")
    post panic_path

    get coordinator_path
    assert_match "1 contacts alerted", response.body
    assert_match "Mark all reviewed", response.body

    post coordinator_review_path
    assert_redirected_to coordinator_path

    follow_redirect!
    assert_match "reviewed", response.body
    assert_equal(1, PanicAlert.where.not(reviewed_at: nil).count)
  end
end
