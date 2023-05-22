require 'epubinfo'
require 'nokogiri'
class BooksController < ApplicationController
  before_action :set_book, only: %i[ show update destroy ]
  rescue_from ActiveRecord::Rollback, with: :handle_rollback

  # GET /books
  def index
    @books = Book.all

    render json: @books
  end

  # GET /books/1
  def show
    render json: @book
  end

  # POST /books
  def create
    ActiveRecord::Base.transaction do
      begin
        params[:books].each do |book|
          Book.create!(title: book[:title], description: book[:description], image_cover_link: book[:image_cover_link],
          type: book[:type], file_link: book[:file_link], price: book[:price])
        end
        render json: {success: true}
      rescue ActiveRecord::RecordInvalid => e
        render json: { error: e.message }, status: :unprocessable_entity
        raise ActiveRecord::Rollback
      end
    end
  end

  # PATCH/PUT /books/1
  def update
    if @book.update(book_params)
      render json: @book
    else
      render json: @book.errors, status: :unprocessable_entity
    end
  end

  # DELETE /books/1
  def destroy
    @book.destroy
  end

  def set_book_as_active
    ActiveRecord::Base.transaction do
      begin
        book_id = params[:book_id].to_i
        collection_id = params[:collection_id].to_i
        booksCollections = BooksCollection.where(:book_id => params[:book_id], :collection_id => params[:collection_id], :is_active => false)
        if !booksCollections.any?
          raise StandardError, 'Not Found'
        else
          booksCollections.update_all(:is_active => true)
        end
        render json: {success: true}
      rescue => e
        render json: { error: e.message }, status: :unprocessable_entity
        raise ActiveRecord::Rollback
      end
    end
  end

  def export
    begin
      book_id = params[:book_id].to_i
      book = Book.find(book_id)
      mobi_file_path = book[:file_link]
      output_file_path = gen_file_base_format(params[:format])
      if params[:format] == 'pdf' || params[:format] == 'docx'
        generate_file(mobi_file_path, output_file_path)
        return
      else
        intermediate_path = 'D:/kindle_assignment/storage/file/exported.epub'
        output_file_name = (params[:format] == 'html') ? 'exported.html' : 'exported.jpg'
        system("ebook-convert #{mobi_file_path} #{intermediate_path}")
        system("kindlegen #{intermediate_path} -c2 -o #{output_file_name}")
        render json: {success: true, file_path: output_file_path}
        return
      end
    rescue => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def book_params
      params.fetch(:book, {})
    end

    def handle_rollback(exception)
      # Perform additional actions or cleanup tasks after rollback
      # This method will be called when a rollback occurs in the create action
      render json: {msg: exception}, status: :unprocessable_entity
    end
end
