class PushNotificationJob < ApplicationJob
  queue_as :default

  # Send push notifications to all subscriptions for a user
  # except those on devices that are currently connected
  def perform(user_id, title:, body:, path: "/")
    return unless PushSubscription.configured?

    user = User.find_by(id: user_id)
    return unless user

    user.push_subscriptions.find_each do |subscription|
      subscription.send_notification(
        title: title,
        body: body,
        path: path
      )
    end
  end
end
