# app/controllers/api/v1/broadcasts_controller.rb
module Api
  module V1
    class BroadcastsController < ApplicationController
      before_action :authenticate_user!

      def index
        broadcasts = current_user.broadcasts.order(created_at: :desc)
        render json: broadcasts
      end

      def create
        broadcast = current_user.broadcasts.new(broadcast_params.merge(status: 'pending'))
        if broadcast.save
          # Optional: broadcast via ActionCable to dashboard
          ActionCable.server.broadcast("broadcasts_channel", { action: 'created', broadcast: broadcast.as_json })
          render json: broadcast, status: :created
        else
          render json: { errors: broadcast.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def show
        broadcast = current_user.broadcasts.find(params[:id])
        render json: broadcast
      end

      # POST /api/v1/broadcasts/:id/send_broadcast
      def send_broadcast
        broadcast = current_user.broadcasts.find(params[:id])
        # trigger job
        BroadcastSenderJob.perform_later(broadcast.id, current_user.id)
        render json: { status: 'queued' }, status: :accepted
      end

      private

      def broadcast_params
        params.require(:broadcast).permit(:title, :message)
      end
    end
  end
end
