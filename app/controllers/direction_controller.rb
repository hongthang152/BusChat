class DirectionController < ApplicationController
  def index
    render json: DirectionService.new.call(parameters)
  end

  def parameters
    params.permit(:from, :to)
  end
end
