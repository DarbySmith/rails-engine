class Api::V1::SearchItemsController < ApplicationController
  def show
    if !Item.search_one_name(params[:name]).nil?
      render json: ItemSerializer.new(Item.search_one_name(params[:name]))
    else
      render json: { errors: 'item not found'}, status: 404
    end
  end
end