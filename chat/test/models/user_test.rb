require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "downcases and strips email_address" do
    user = User.new(email_address: " DOWNCASED@EXAMPLE.COM ")

    assert_equal "downcased@example.com", user.email_address
  end

  test "validates presence of email_address" do
    user = User.new(
      email_address: nil,
      password: "password123",
      account: accounts(:one)
    )

    assert_not user.valid?
    assert_includes user.errors[:email_address], "can't be blank"
  end

  test "validates uniqueness of email_address" do
    existing_user = users(:one)
    user = User.new(
      email_address: existing_user.email_address,
      password: "password123",
      account: accounts(:one)
    )

    assert_not user.valid?
    assert_includes user.errors[:email_address], "has already been taken"
  end

  test "validates presence of password on create" do
    user = User.new(
      email_address: "new@example.com",
      password: "",
      account: accounts(:one)
    )

    assert_not user.valid?
    assert_includes user.errors[:password], "can't be blank"
  end

  test "belongs to account" do
    user = users(:one)

    assert_instance_of Account, user.account
    assert_equal accounts(:one), user.account
  end

  test "has many sessions" do
    user = users(:one)
    user.sessions.create!

    assert_equal 1, user.sessions.count
  end

  test "destroys sessions when destroyed" do
    user = users(:one)
    user.sessions.create!
    session_count_before = Session.count

    user.destroy

    assert_equal session_count_before - 1, Session.count
  end
end
