class UsersController < ApplicationController
  before_action :set_user, only: %i[ show update destroy ]
  before_action :authorize_request, only: [:add_book_to_collection, :remove_book_from_collection, :remember_last_page, :get_purchased_books_for_user]

  # GET /users
  def index
    @users = User.all

    render json: @users
  end

  # GET /users/1
  def show
    render json: @user
  end

  # POST /users
  def create
    @user = User.new(params.require(:user).permit(:username, :email, :password))

    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
  end

  def login
    user = User.find_by(email: params[:email])
    if !user.nil?
      if user.authenticate(params[:password])
        access_token = JsonWebTokenService.encode({user_id: user.id})
        refresh_token = JsonWebTokenService.encode({user_id: user.id}, 7.days.from_now)
        render json: {
                success: true,
                data: {
                access_token: "Bearer #{access_token}",
                refresh_token: "Bearer #{refresh_token}",
                expires: "24h"
                }}
      else
        render json: {success: false}, status: :unprocessable_entity
      end
    else
      render json: {success: false}, status: :unprocessable_entity
    end
  end

  def check_valid_collection(collection_id)
    current_collections = @current_user.collections.map do |collection|
      collection.id
    end
    if (!current_collections.include?(collection_id))
      raise StandardError, "Not valid collection"
    end
  end

  def check_params_for_remember_page(book, page)
    if !book.instance_of?(Kindle) || !(page.is_a? Integer) || page <= 0
      raise StandardError, 'Invalid Input'
    end
  end

  def add_book_to_collection
    
    ActiveRecord::Base.transaction do
      begin
        collection_id = params[:collection_id].to_i
        check_valid_collection(collection_id)
        collection = Collection.find(collection_id)
        params[:book_ids].each do |id|
          book = Book.find(id)
          if book.instance_of?(Kindle)
            collection.books_collections << BooksCollection.create!(collection: collection, book: book, current_page: 0, is_active: false)
          else
            collection.books_collections << BooksCollection.create!(collection: collection, book: book, current_page: nil, is_active: false)
          end
        end
        render json: {success: true}
      rescue => e
        handle_exception(e)
      end
    end
  end

  def remove_book_from_collection
    
    ActiveRecord::Base.transaction do
      begin
        collection_id = params[:collection_id].to_i
        check_valid_collection(collection_id)
        collection = Collection.find(collection_id)
        params[:book_ids].each do |id|
          book = Book.find(id)
          bookCollection = BooksCollection.where(:book_id => book.id, :collection_id => collection.id)
          if !bookCollection.any?
            raise StandardError, "Not Found record"
          else
            bookCollection.delete_all
          end
        end
        render json: {success: true}
      rescue => e
        handle_exception(e)
      end
    end
  end

  def remember_last_page
    
    ActiveRecord::Base.transaction do
      begin
        collection_id = params[:collection_id].to_i
        book_id = params[:book_id].to_i
        page = params[:page].to_i
        check_valid_collection(collection_id)
        collection = Collection.find(collection_id)
        book = Book.find(book_id)
        check_params_for_remember_page(book, page)
        booksCollections = BooksCollection.where(:book_id => book_id, :collection_id => collection_id)
        if !booksCollections.any?
          raise StandardError, 'Not Found'
        else
          booksCollections.update_all(:current_page => page)
        end
        render json: {success: true}
      rescue => e
        handle_exception(e)
      end
    end


  end

  def get_purchased_books_for_user
    books = []
    @current_user.transactions.each do |transaction|
      transaction.books.each do |book|
        if !books.include? book
          books << book
        end
      end
    end
    render json:{data: books}
  end

  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.fetch(:user, {})
    end
end
