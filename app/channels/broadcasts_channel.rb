class BroadcastsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "broadcasts_channel"
  end
end
