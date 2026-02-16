require "test_helper"

class PushSubscriptionsControllerTest < ActionDispatch::IntegrationTest
  # Authentication

  test "create requires authentication" do
    post push_subscriptions_path, params: {
      push_subscription: {
        endpoint: "https://push.example.com/new",
        p256dh: "test-key",
        auth: "test-auth"
      }
    }

    assert_redirected_to new_session_path
  end

  test "destroy requires authentication" do
    subscription = push_subscriptions(:one)

    delete push_subscription_path(subscription), params: { endpoint: subscription.endpoint }

    assert_redirected_to new_session_path
  end

  test "vapid_public_key requires authentication" do
    get vapid_public_key_push_subscriptions_path

    assert_redirected_to new_session_path
  end

  # CREATE

  test "create creates new subscription for authenticated user" do
    sign_in_as users(:one)

    assert_difference "PushSubscription.count", 1 do
      post push_subscriptions_path, params: {
        push_subscription: {
          endpoint: "https://push.example.com/unique-endpoint-#{SecureRandom.hex}",
          p256dh: "new-p256dh-key",
          auth: "new-auth-key"
        }
      }
    end

    assert_response :created
    subscription = PushSubscription.last
    assert_equal users(:one), subscription.user
    assert_equal "new-p256dh-key", subscription.p256dh
    assert_equal "new-auth-key", subscription.auth
  end

  test "create updates existing subscription with same endpoint" do
    sign_in_as users(:one)
    existing = push_subscriptions(:one)

    assert_no_difference "PushSubscription.count" do
      post push_subscriptions_path, params: {
        push_subscription: {
          endpoint: existing.endpoint,
          p256dh: "updated-p256dh-key",
          auth: "updated-auth-key"
        }
      }
    end

    assert_response :created
    existing.reload
    assert_equal "updated-p256dh-key", existing.p256dh
    assert_equal "updated-auth-key", existing.auth
  end

  test "create returns unprocessable_entity with invalid params" do
    sign_in_as users(:one)

    assert_no_difference "PushSubscription.count" do
      post push_subscriptions_path, params: {
        push_subscription: {
          endpoint: "",
          p256dh: "key",
          auth: "auth"
        }
      }
    end

    assert_response :unprocessable_entity
  end

  test "create only creates subscription for current user" do
    sign_in_as users(:one)

    post push_subscriptions_path, params: {
      push_subscription: {
        endpoint: "https://push.example.com/user-one-endpoint",
        p256dh: "key",
        auth: "auth"
      }
    }

    subscription = PushSubscription.find_by(endpoint: "https://push.example.com/user-one-endpoint")
    assert_equal users(:one), subscription.user
  end

  # DESTROY

  test "destroy removes subscription by endpoint" do
    sign_in_as users(:one)
    subscription = push_subscriptions(:one)

    assert_difference "PushSubscription.count", -1 do
      delete push_subscription_path(subscription), params: { endpoint: subscription.endpoint }
    end

    assert_response :ok
    assert_nil PushSubscription.find_by(id: subscription.id)
  end

  test "destroy returns ok even if endpoint not found for user" do
    sign_in_as users(:one)
    subscription = push_subscriptions(:one)

    # First delete actually removes it
    delete push_subscription_path(subscription), params: { endpoint: subscription.endpoint }
    assert_response :ok

    # Second delete with same ID but endpoint not found should still return ok
    # (the controller uses find_by which returns nil, then &.destroy does nothing)
    delete push_subscription_path(subscription), params: { endpoint: "https://nonexistent.example.com" }
    assert_response :ok
  end

  test "destroy only removes subscriptions belonging to current user" do
    sign_in_as users(:one)
    other_user_subscription = push_subscriptions(:two)

    # The endpoint param is used to find within current user's subscriptions
    # So even though we're hitting the route, the endpoint won't be found for user one
    assert_no_difference "PushSubscription.count" do
      delete push_subscription_path(other_user_subscription), params: { endpoint: other_user_subscription.endpoint }
    end

    assert_response :ok
    # Subscription still exists because it belongs to another user
    assert PushSubscription.exists?(other_user_subscription.id)
  end

  # VAPID_PUBLIC_KEY

  test "vapid_public_key returns key when configured" do
    sign_in_as users(:one)

    original_public = ENV["VAPID_PUBLIC_KEY"]
    original_private = ENV["VAPID_PRIVATE_KEY"]

    ENV["VAPID_PUBLIC_KEY"] = "test-vapid-public-key"
    ENV["VAPID_PRIVATE_KEY"] = "test-vapid-private-key"

    get vapid_public_key_push_subscriptions_path, as: :json

    assert_response :success
    json = JSON.parse(response.body)
    assert_equal "test-vapid-public-key", json["vapid_public_key"]
  ensure
    ENV["VAPID_PUBLIC_KEY"] = original_public
    ENV["VAPID_PRIVATE_KEY"] = original_private
  end

  test "vapid_public_key returns service_unavailable when not configured" do
    sign_in_as users(:one)

    original_public = ENV["VAPID_PUBLIC_KEY"]
    original_private = ENV["VAPID_PRIVATE_KEY"]

    ENV["VAPID_PUBLIC_KEY"] = nil
    ENV["VAPID_PRIVATE_KEY"] = nil

    get vapid_public_key_push_subscriptions_path, as: :json

    assert_response :service_unavailable
    json = JSON.parse(response.body)
    assert_nil json["vapid_public_key"]
  ensure
    ENV["VAPID_PUBLIC_KEY"] = original_public
    ENV["VAPID_PRIVATE_KEY"] = original_private
  end
end
