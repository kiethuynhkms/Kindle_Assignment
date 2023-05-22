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

    def generate_file(input_file_path, output_file_path)
        begin
            system("ebook-convert #{input_file_path} #{output_file_path}")
            render json: {success: true, file_path: output_file_path}
        rescue Errno::ENOENT, RuntimeError => e
            raise e
        end
    end

    def handle_exception(e)
        render json: { error: e.message }, status: :unprocessable_entity
        raise ActiveRecord::Rollback
    end

    def gen_file_base_format(format)
        case format
        when "pdf"
          # Code to execute for option 1
          return 'D:/kindle_assignment/storage/file/exported.pdf'
        when "docx"
          # Code to execute for option 2
          return 'D:/kindle_assignment/storage/file/exported.docx'
        when "html"
          # Code to execute for option 3
          return 'D:/kindle_assignment/storage/file/exported.html'
        when "jpg"
            # Code to execute for option 3
            return 'D:/kindle_assignment/storage/file/exported.jpg'
        else
          # Code to execute when none of the options match
          raise StandardError, 'Not Support format'
        end
    
      end
end
