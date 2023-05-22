class HighlightsController < ApplicationController
  before_action :set_highlight, only: %i[ show update destroy ]
  before_action :authorize_request, only: [:create]

  # GET /highlights
  def index
    @highlights = Highlight.all

    render json: @highlights
  end

  # GET /highlights/1
  def show
    render json: @highlight
  end

  # POST /highlights
  def create
    @highlight = Highlight.new(x: params[:x], y: params[:y], width: params[:width], height: params[:height], comment: params[:comment], user: @current_user, book_id: params[:book_id], page: params[:page],
                              page_width: params[:page_width], page_height: params[:page_height])

    if @highlight.save
      render json: @highlight, status: :created, location: @highlight
    else
      render json: @highlight.errors, status: :unprocessable_entity
    end
  end

  def get_highlights_by_page_of_book
    highlights = Highlight.where( :book_id => params[:book_id].to_i, :page => params[:page].to_i)
    render json: {data: highlights}
  end

  # PATCH/PUT /highlights/1
  def update
    if @highlight.update(highlight_params)
      render json: @highlight
    else
      render json: @highlight.errors, status: :unprocessable_entity
    end
  end

  # DELETE /highlights/1
  def destroy
    @highlight.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_highlight
      @highlight = Highlight.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def highlight_params
      params.fetch(:highlight, {})
    end
end
