class ApplicationController < ActionController::API

    def authorize_request
        header = request.headers['Authorization']
        header = header.split(' ').last if header
        begin
            payload = JsonWebTokenService.decode(header)
            @current_user = User.includes(:collections).find(payload[:user_id])
        rescue JWT::DecodeError
            render json: { message: 'Invalid token' }, status: :unauthorized
        end
    end

    def handle_exception(e)
        render json: { error: e.message }, status: :unprocessable_entity
        raise ActiveRecord::Rollback
    end
end
