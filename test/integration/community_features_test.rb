require "test_helper"

class CommunityFeaturesTest < ActionDispatch::IntegrationTest
  setup do
    @setting = Setting.create!(pin: "2500", values_accepted_at: Time.current, pseudonym: "Tester")
    unlock
  end

  test "panic alert records delivery, location and sms hand-off" do
    Contact.create!(name: "Mumbi", phone: "+254700111222")
    Contact.create!(name: "Ash", phone: "+254700333444")

    assert_difference "PanicAlert.count", 1 do
      post panic_path, params: { latitude: "-1.292066", longitude: "36.821946" }
    end
    assert_redirected_to panic_path
    follow_redirect!
    assert_match "Your circle knows.", response.body
    assert_match "2 trusted contacts", response.body

    alert = PanicAlert.last
    assert_in_delta -1.292066, alert.latitude.to_f, 0.000001
    assert_in_delta 36.821946, alert.longitude.to_f, 0.000001
    assert_match %r{\A\d+/\d+ SMS}, alert.sms_status
  end

  test "chat list shows conversations and messages can be sent to a thread" do
    conversation = Conversation.create!(title: "Mumbi", color: "#c29765")

    get chat_path
    assert_response :success
    assert_match "Chats", response.body

    assert_difference "Message.count", 1 do
      post chat_messages_path(conversation), params: { message: { body: "I'm safe tonight" } }
    end
    assert_redirected_to chat_thread_path(conversation)
    follow_redirect!
    assert_match "I&#39;m safe tonight", response.body
  end

  test "per-message delete timer removes the message after it expires" do
    conversation = Conversation.create!(title: "Ash", color: "#a9bd7e")

    travel_to Time.current do
      post chat_messages_path(conversation),
           params: { message: { body: "delete me soon", expires_in: "1" } }
      follow_redirect!
      assert_match "delete me soon", response.body
    end

    travel 2.minutes do
      get chat_thread_path(conversation)
      assert_response :success
      assert_no_match "delete me soon", response.body
      refute Message.exists?(body: "delete me soon")
    end
  end

  test "aid feed and request detail are separate screens" do
    request = AidRequest.create!(title: "Clinic fee", target_amount: 1_000, deadline: 5.days.from_now, status: "open")

    get aid_path
    assert_response :success
    assert_match "Clinic fee", response.body

    assert_difference -> { request.pledges.count }, 1 do
      post aid_pledge_path(request)
    end
    assert_redirected_to aid_request_path(request)

    get aid_request_path(request)
    assert_response :success
    assert_match "Pledge ledger", response.body

    post aid_requests_path, params: { aid_request: { title: "Food top-up", target_amount: 800 } }
    assert_redirected_to aid_request_path(AidRequest.find_by!(title: "Food top-up"))
    assert_equal 2, AidRequest.count
  end

  test "a story can be shared under your pseudonym" do
    post community_stories_path, params: { story: { body: "Sunday dinners became family." } }
    assert_redirected_to community_path
    follow_redirect!
    assert_match "Sunday dinners became family.", response.body
    assert_equal "Tester", Story.last.author
  end

  test "community vote increments" do
    vote = VoteProposal.create!(title: "Quiet room", supports_count: 18)

    assert_difference "vote.reload.supports_count", 1 do
      post community_support_path(vote)
    end
    assert_redirected_to community_path
  end

  test "settings persist accessibility and disguise choices" do
    patch settings_path, params: { setting: { text_scale: 22, high_contrast: true, disguise: "Weather" } }
    assert_redirected_to settings_path
    follow_redirect!
    assert_match "high-contrast", response.body
    assert_equal 22, @setting.reload.text_scale
    assert_equal "Weather", @setting.reload.disguise
  end

  private

  def unlock
    post unlock_path, params: { code: "2500" }, as: :json
    assert_response :success
  end
end
