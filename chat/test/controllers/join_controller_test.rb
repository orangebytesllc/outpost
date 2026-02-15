require "test_helper"

class JoinControllerTest < ActionDispatch::IntegrationTest
  test "show renders join form with valid token" do
    get join_path(token: accounts(:one).invite_token)

    assert_response :success
    assert_select "h1", text: /Join Test Account/i
  end

  test "show redirects with invalid token" do
    get join_path(token: "invalid-token")

    assert_redirected_to root_path
  end

  test "show redirects authenticated users" do
    sign_in_as users(:one)

    get join_path(token: accounts(:one).invite_token)

    assert_redirected_to root_path
  end

  test "create registers new user with valid token" do
    assert_difference "User.count", 1 do
      post join_path(token: accounts(:one).invite_token), params: {
        user: {
          email_address: "newuser@example.com",
          password: "password123",
          password_confirmation: "password123"
        }
      }
    end

    assert_redirected_to root_path
    new_user = User.find_by(email_address: "newuser@example.com")
    assert_equal accounts(:one), new_user.account
    assert_not new_user.admin?
  end

  test "create renders form with errors when invalid" do
    assert_no_difference "User.count" do
      post join_path(token: accounts(:one).invite_token), params: {
        user: {
          email_address: "",
          password: "password123",
          password_confirmation: "password123"
        }
      }
    end

    assert_response :unprocessable_entity
  end

  test "create redirects with invalid token" do
    post join_path(token: "invalid-token"), params: {
      user: {
        email_address: "newuser@example.com",
        password: "password123",
        password_confirmation: "password123"
      }
    }

    assert_redirected_to root_path
  end
end
