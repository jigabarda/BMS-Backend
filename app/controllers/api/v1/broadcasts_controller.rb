# app/controllers/api/v1/broadcasts_controller.rb

module Api
  module V1
    class BroadcastsController < BaseController
      before_action :ensure_json_request
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
        broadcast = current_user.broadcasts.new(
          broadcast_params.merge(status: 'pending')
        )

        if broadcast.save
          render json: broadcast, status: :created
        else
          render json: { errors: broadcast.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PUT/PATCH /api/v1/broadcasts/:id
      def update
        broadcast = current_user.broadcasts.find(params[:id])

        if broadcast.update(broadcast_params)
          render json: broadcast, status: :ok
        else
          render json: { errors: broadcast.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/broadcasts/:id
      def destroy
        broadcast = current_user.broadcasts.find(params[:id])
        broadcast.destroy

        head :no_content
      end

      # POST /api/v1/broadcasts/:id/send_broadcast
      def send_broadcast
        return render json: { error: 'Forbidden' }, status: :forbidden unless @broadcast.user_id == current_user.id
        return render json: { error: 'Already sent' }, status: :unprocessable_entity if @broadcast.status == 'sent'

        @broadcast.update!(
          status: 'sent',
          sent_at: Time.current
        )

        # Note: devices column is `token` in your current schema. Use that.
        tokens = current_user.devices.pluck(:token).compact

        # Send notifications (service is a no-op logger by default)
        begin
          PushNotificationSender.send_notification(tokens, {
            title: @broadcast.title,
            body: @broadcast.message
          })
        rescue => e
          Rails.logger.error "PushNotificationSender error: #{e.class} #{e.message}"
          # If you want the failure to fail the request, uncomment:
          # render json: { error: 'Failed to send notifications' }, status: :internal_server_error and return
        end

        render json: { status: 'sent', pushed_to: tokens.count }, status: :ok
      end

      private

      # Ensures API requests are always JSON.
      def ensure_json_request
        return if request.format.json?

        render json: { error: "JSON format required" }, status: :not_acceptable
      end

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
