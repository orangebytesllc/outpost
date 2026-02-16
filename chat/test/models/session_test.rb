require "test_helper"

class SessionTest < ActiveSupport::TestCase
  # Associations

  test "belongs to user" do
    session = sessions(:one)

    assert_instance_of User, session.user
    assert_equal users(:one), session.user
  end

  # Creation

  test "creates valid session with user" do
    session = Session.new(user: users(:one))

    assert session.valid?
    assert session.save
  end

  test "creates session with user_agent and ip_address" do
    session = Session.new(
      user: users(:one),
      user_agent: "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)",
      ip_address: "192.168.1.100"
    )

    assert session.valid?
    assert session.save
    assert_equal "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)", session.user_agent
    assert_equal "192.168.1.100", session.ip_address
  end

  test "requires user association" do
    session = Session.new(user: nil)

    assert_not session.valid?
    assert_includes session.errors[:user], "must exist"
  end

  # Dependent destroy

  test "is destroyed when user is destroyed" do
    user = users(:one)
    session_count_before = user.sessions.count

    # Ensure there's at least one session
    user.sessions.create! if session_count_before == 0
    session_count_before = user.sessions.count

    assert session_count_before > 0

    user.destroy

    assert_equal 0, Session.where(user_id: user.id).count
  end

  # Multiple sessions per user

  test "user can have multiple sessions" do
    user = users(:one)

    session1 = user.sessions.create!(
      user_agent: "Browser 1",
      ip_address: "10.0.0.1"
    )

    session2 = user.sessions.create!(
      user_agent: "Browser 2",
      ip_address: "10.0.0.2"
    )

    assert_includes user.sessions, session1
    assert_includes user.sessions, session2
    assert user.sessions.count >= 2
  end

  # Timestamps

  test "session has timestamps" do
    session = Session.create!(user: users(:one))

    assert_not_nil session.created_at
    assert_not_nil session.updated_at
  end
end
