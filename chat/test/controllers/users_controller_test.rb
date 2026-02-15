require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "update toggles admin status" do
    sign_in_as users(:one)
    user_to_update = users(:two)

    patch user_path(user_to_update), params: { admin: true }, as: :json

    assert_response :ok
    assert user_to_update.reload.admin?
  end

  test "update toggles admin off" do
    sign_in_as users(:one)
    user_to_update = users(:two)
    user_to_update.update!(admin: true)

    patch user_path(user_to_update), params: { admin: false }, as: :json

    assert_response :ok
    assert_not user_to_update.reload.admin?
  end

  test "update redirects non-admin users" do
    sign_in_as users(:two)

    patch user_path(users(:one)), params: { admin: true }, as: :json

    assert_redirected_to root_path
  end

  test "destroy deletes a user" do
    sign_in_as users(:one)
    user_to_delete = users(:two)

    assert_difference "User.count", -1 do
      delete user_path(user_to_delete)
    end

    assert_redirected_to settings_path
  end

  test "destroy prevents deleting yourself" do
    sign_in_as users(:one)

    assert_no_difference "User.count" do
      delete user_path(users(:one))
    end

    assert_redirected_to settings_path
    follow_redirect!
    assert_select "p", text: /cannot delete yourself/i
  end

  test "destroy redirects non-admin users" do
    sign_in_as users(:two)

    assert_no_difference "User.count" do
      delete user_path(users(:one))
    end

    assert_redirected_to root_path
  end

  test "cannot update users from other accounts" do
    sign_in_as users(:one)
    other_account = Account.create!(name: "Other Account")
    other_user = other_account.users.create!(
      email_address: "other@example.com",
      password: "password123"
    )

    patch user_path(other_user), params: { admin: true }, as: :json

    assert_response :not_found
  end
end
