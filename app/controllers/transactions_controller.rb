class TransactionsController < ApplicationController
  before_action :set_transaction, only: %i[ show update destroy ]
  before_action :authorize_request, only: [:create]

  # GET /transactions
  def index
    @transactions = Transaction.all

    render json: @transactions
  end

  # GET /transactions/1
  def show
    render json: @transaction
  end

  def check_stock_available(book_id, stock_id, quantity)
      stockables = Stockable.where( :stockable_type => 'Book', :stock_id => stock_id, :stockable_id => book_id)
      if !stockables.any?
          raise StandardError, 'Book is not available in stock'
      else
        if stockables[0][:amount] < quantity
          raise StandardError, 'Book is not enough for demand'
        end
      end
  end

  # POST /transactions
  def create
    ActiveRecord::Base.transaction do
      begin
        #should use third party for purchase
        transaction = Transaction.create(user: @current_user, total: params[:total])
        params[:items].each do |item|
          book = Book.find(item[:book_id])
          if book.instance_of?(Hard)
            stock = Stock.find(item[:stock_id])
            check_stock_available(item[:book_id], item[:stock_id], item[:quantity])
            BooksTransaction.create!(transaction_model: transaction, book: book,
                                              stock: stock, quantity: item[:quantity])
          else
            BooksTransaction.create!(transaction_model: transaction, book: book, quantity: 1)
          end
        end
        render json: {success: true}
      rescue => e
        handle_exception(e)
      end
    end
  end

  # PATCH/PUT /transactions/1
  def update
    if @transaction.update(transaction_params)
      render json: @transaction
    else
      render json: @transaction.errors, status: :unprocessable_entity
    end
  end

  # DELETE /transactions/1
  def destroy
    @transaction.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transaction
      @transaction = Transaction.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def transaction_params
      params.fetch(:transaction, {})
    end
end
