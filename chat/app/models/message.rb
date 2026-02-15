class Message < ApplicationRecord
  belongs_to :room
  belongs_to :user

  validates :body, presence: true

  after_create_commit :broadcast_create
  after_update_commit :broadcast_update
  after_destroy_commit :broadcast_destroy

  private

  def broadcast_create
    MessageBroadcast.new(self).deliver_create
  end

  def broadcast_update
    MessageBroadcast.new(self).deliver_update
  end

  def broadcast_destroy
    MessageBroadcast.new(self).deliver_destroy
  end
end
