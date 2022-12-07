class Api::V1::ItemsController < ApplicationController
  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    if Item.exists?(params[:id])
      render json: ItemSerializer.new(Item.find(params[:id]))
    else
      render json: {errors: "item does not exist"}, status: 404
    end
  end

  def create
    if Item.new(item_params).save
      render json: ItemSerializer.new(Item.create!(item_params)), status: :created
    else 
      render json: { errors: "item not created" }, status: 400
    end
  end

  def update
    if Item.exists?(params[:id]) && Item.update(params[:id], item_params).save 
      render json: ItemSerializer.new(Item.update(params[:id], item_params))
    else
      render json: {errors: "unable to update" }, status: 404
    end
  end

  def destroy
    Item.destroy(params[:id])
  end

  private
    def item_params
      params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
    end
end