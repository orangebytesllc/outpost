require "test_helper"

class MessageBroadcastTest < ActiveSupport::TestCase
  test "deliver_create broadcasts message to room without raising" do
    message = messages(:hello)
    broadcast = MessageBroadcast.new(message)

    assert_nothing_raised do
      broadcast.deliver_create
    end
  end

  test "deliver_update broadcasts message replacement to room without raising" do
    message = messages(:hello)
    broadcast = MessageBroadcast.new(message)

    assert_nothing_raised do
      broadcast.deliver_update
    end
  end

  test "deliver_destroy broadcasts message removal to room without raising" do
    message = messages(:hello)
    broadcast = MessageBroadcast.new(message)

    assert_nothing_raised do
      broadcast.deliver_destroy
    end
  end

  test "preloads user with avatar attachment" do
    message = messages(:hello)
    broadcast = MessageBroadcast.new(message)

    preloaded = broadcast.send(:preloaded_message)

    assert_equal message.id, preloaded.id
    assert preloaded.user.present?
  end
end
