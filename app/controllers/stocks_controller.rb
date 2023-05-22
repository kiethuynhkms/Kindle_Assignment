class StocksController < ApplicationController
  before_action :set_stock, only: %i[ show update destroy ]

  # GET /stocks
  def index
    @stocks = Stock.all

    render json: @stocks
  end

  # GET /stocks/1
  def show
    render json: @stock
  end

  # POST /stocks
  def create
    @stock = Stock.new(name: params[:name], location: params[:location])

    if @stock.save
      render json: @stock, status: :created, location: @stock
    else
      render json: @stock.errors, status: :unprocessable_entity
    end
  end

  def add_book_to_stock
    ActiveRecord::Base.transaction do
      begin
        book_id = params[:book_id]
        stock_id = params[:stock_id]
        amount = params[:amount]
        stock = Stock.find(stock_id)
        book = Book.find(book_id)
        if !book.instance_of?(Hard) || amount <= 0
          raise StandardError, "Invalid Input"
        end
        stockable = Stockable.create(stock: stock, stockable_type: 'Book', stockable_id: book.id, amount: amount)
        stock.stockables << stockable
        stock.save
        render json: {success: true}
      rescue => e
        handle_exception(e)
      end
    end
  end

  # PATCH/PUT /stocks/1
  def update
    if @stock.update(stock_params)
      render json: @stock
    else
      render json: @stock.errors, status: :unprocessable_entity
    end
  end

  # DELETE /stocks/1
  def destroy
    @stock.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_stock
      @stock = Stock.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def stock_params
      params.fetch(:stock, {})
    end
end
