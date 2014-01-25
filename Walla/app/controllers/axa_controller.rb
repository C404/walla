class AxaController < ApplicationController
  def create
    begin
      @doc = AxaDocument.new(params[:document]).store!
      render nothing: true, status: :ok
    rescue
      render nothing: true, status: :not_found
    end
  end

  def index
    @results = AxaDocument.query(params[:q])
    render json: @results[0, 30].map { |r| {url: r.url} }
  end
end
