require "test_helper"

class SetupControllerTest < ActionDispatch::IntegrationTest
  test "new shows setup form when no account exists" do
    User.delete_all
    Account.delete_all

    get new_setup_path

    assert_response :success
    assert_select "h1", text: /Set up Outpost/i
  end

  test "new redirects to root when account already exists" do
    get new_setup_path

    assert_redirected_to root_path
  end

  test "create sets up account and admin user" do
    User.delete_all
    Account.delete_all

    post setup_path, params: {
      account: { name: "My Team" },
      user: {
        name: "Admin User",
        email_address: "admin@example.com",
        password: "password123",
        password_confirmation: "password123"
      }
    }

    assert_redirected_to root_path
    assert_equal 1, Account.count
    assert_equal "My Team", Account.first.name
    assert_equal 1, User.count
    assert_equal "admin@example.com", User.first.email_address
    assert User.first.admin?
  end

  test "create renders form with errors when account name is blank" do
    User.delete_all
    Account.delete_all

    post setup_path, params: {
      account: { name: "" },
      user: {
        email_address: "admin@example.com",
        password: "password123",
        password_confirmation: "password123"
      }
    }

    assert_response :unprocessable_entity
    assert_equal 0, Account.count
  end

  test "create renders form with errors when passwords do not match" do
    User.delete_all
    Account.delete_all

    post setup_path, params: {
      account: { name: "My Team" },
      user: {
        email_address: "admin@example.com",
        password: "password123",
        password_confirmation: "different"
      }
    }

    assert_response :unprocessable_entity
    assert_equal 0, Account.count
  end
end
