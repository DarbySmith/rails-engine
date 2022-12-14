class Api::V1::MerchantItemsController < ApplicationController
  def index
    if Merchant.exists?(params[:merchant_id])
      render json: ItemSerializer.new(Item.where(merchant_id: params[:merchant_id]))
    else
      render json: { errors: "unable to find" }, status: 404
    end
  end
end