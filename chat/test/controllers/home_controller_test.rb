require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "redirects to setup when no account exists" do
    User.delete_all
    Account.delete_all

    get root_path

    assert_redirected_to new_setup_path
  end

  test "redirects to sign in when not authenticated" do
    get root_path

    assert_redirected_to new_session_path
  end

  test "shows home page when authenticated" do
    sign_in_as users(:one)

    get root_path

    assert_response :success
    assert_select "h1", text: /Test Account/i
  end
end
