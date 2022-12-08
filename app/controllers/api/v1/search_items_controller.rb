class Api::V1::SearchItemsController < ApplicationController
  def show
    if (params[:name] && params[:min_price]) || (params[:name] && params[:max_price])
      render json: { data: { errors: 'cannot send name with price'}}, status: 400
    elsif params[:name]
      if !Item.search_one_name(params[:name]).nil?
        render json: ItemSerializer.new(Item.search_one_name(params[:name]))
      else
        render json: { data: { errors: 'item not found'} }, status: 404
      end
    elsif params[:min_price] && params[:max_price]
      if !Item.search_price(params[:min_price], params[:max_price]).nil?
        render json: ItemSerializer.new(Item.search_price(params[:min_price], params[:max_price]))
      else
        render json: { data: { errors: 'item not found'}}, status: 404
      end
    elsif params[:min_price]
      if !Item.search_min_price(params[:min_price]).nil?
        render json: ItemSerializer.new(Item.search_min_price(params[:min_price]))
      else
        render json: { data: { errors: 'item not found'}}, status: 404
      end
    elsif params[:max_price]
      if !Item.search_max_price(params[:max_price]).nil?
        render json: ItemSerializer.new(Item.search_max_price(params[:max_price]))
      else
        render json: { data: { errors: 'item not found'}}, status: 404
      end
    end
  end
end