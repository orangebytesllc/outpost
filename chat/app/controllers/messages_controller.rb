class MessagesController < ApplicationController
  before_action :set_room
  before_action :set_message, only: [ :update, :destroy ]
  before_action :authorize_message, only: [ :update, :destroy ]

  def create
    @message = @room.messages.build(message_params)
    @message.user = Current.user

    respond_to do |format|
      if @message.save
        format.turbo_stream
        format.html { redirect_to @room }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace("message_form", partial: "messages/form", locals: { room: @room, message: @message }) }
        format.html { redirect_to @room, alert: "Message could not be sent." }
      end
    end
  end

  def update
    respond_to do |format|
      if @message.update(message_params)
        format.turbo_stream
        format.html { redirect_to @room }
      else
        format.turbo_stream { head :unprocessable_entity }
        format.html { redirect_to @room, alert: "Message could not be updated." }
      end
    end
  end

  def destroy
    @message.destroy

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @room }
    end
  end

  private

  def set_room
    @room = Current.user.rooms.find(params[:room_id])
  end

  def set_message
    @message = @room.messages.find(params[:id])
  end

  def authorize_message
    unless @message.user == Current.user
      redirect_to @room, alert: "You can only modify your own messages."
    end
  end

  def message_params
    params.require(:message).permit(:body)
  end
end
