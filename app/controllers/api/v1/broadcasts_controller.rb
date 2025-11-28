# app/controllers/api/v1/broadcasts_controller.rb

module Api
  module V1
    class BroadcastsController < BaseController
      
      before_action :set_broadcast, only: [:show, :send_broadcast]

      # GET /api/v1/broadcasts
      def index
        broadcasts = current_user.broadcasts.order(created_at: :desc)
        render json: broadcasts, status: :ok
      end

      # GET /api/v1/broadcasts/:id
      def show
        render json: @broadcast, status: :ok
      end

      # POST /api/v1/broadcasts
      def create
        broadcast = current_user.broadcasts.new(broadcast_params.merge(status: 'pending'))
        if broadcast.save
          # optionally broadcast to ActionCable channel
          ActionCable.server.broadcast("broadcasts_channel_user_#{current_user.id}", {
            action: 'created',
            broadcast: broadcast.as_json
          })
          render json: broadcast, status: :created
        else
          render json: { errors: broadcast.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # POST /api/v1/broadcasts/:id/send_broadcast
      def send_broadcast
        return render json: { error: 'Forbidden' }, status: :forbidden unless @broadcast.user_id == current_user.id
        return render json: { error: 'Already sent' }, status: :unprocessable_entity if @broadcast.status == 'sent'

        @broadcast.update!(status: 'queued')
        BroadcastSenderJob.perform_later(@broadcast.id)
        render json: { status: 'queued' }, status: :accepted
      end

      private

      def set_broadcast
        @broadcast = current_user.broadcasts.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Broadcast not found' }, status: :not_found
      end

      def broadcast_params
        params.require(:broadcast).permit(:title, :message)
      end
    end
  end
end
