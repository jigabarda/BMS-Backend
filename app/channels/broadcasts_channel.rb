class BroadcastsChannel < ApplicationCable::Channel
  def subscribed
    # subscribe to a user-specific stream; client should use param user_id
    # Example: App.cable.subscriptions.create({ channel: "BroadcastsChannel", user_id: 1 })
    stream_from "broadcasts_channel_user_#{params[:user_id]}"
  end

  def unsubscribed
    # cleanup if needed
  end
end
