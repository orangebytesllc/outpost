class MessageBroadcast
  def initialize(message)
    @message = message
  end

  def deliver_create
    @message.broadcast_append_to @message.room,
      target: "messages",
      partial: "messages/message",
      locals: { message: preloaded_message }
  end

  def deliver_update
    @message.broadcast_replace_to @message.room,
      target: ActionView::RecordIdentifier.dom_id(@message),
      partial: "messages/message",
      locals: { message: preloaded_message }
  end

  def deliver_destroy
    @message.broadcast_remove_to @message.room,
      target: ActionView::RecordIdentifier.dom_id(@message)
  end

  private

  def preloaded_message
    Message.includes(user: { avatar_attachment: :blob }).find(@message.id)
  end
end
