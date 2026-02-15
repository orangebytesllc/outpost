require "test_helper"

class SettingsControllerTest < ActionDispatch::IntegrationTest
  test "show redirects non-admin users" do
    sign_in_as users(:two)

    get settings_path

    assert_redirected_to root_path
  end

  test "show renders for admin users" do
    sign_in_as users(:one)

    get settings_path

    assert_response :success
    assert_select "h1", text: /Settings/i
  end

  test "show displays invite link" do
    sign_in_as users(:one)

    get settings_path

    assert_select "input[value*='join/test-invite-token-123']"
  end

  test "regenerate_invite_token changes the token" do
    sign_in_as users(:one)
    old_token = accounts(:one).invite_token

    post regenerate_invite_token_settings_path

    assert_redirected_to settings_path
    assert_not_equal old_token, accounts(:one).reload.invite_token
  end

  test "regenerate_invite_token redirects non-admin users" do
    sign_in_as users(:two)

    post regenerate_invite_token_settings_path

    assert_redirected_to root_path
  end
end
