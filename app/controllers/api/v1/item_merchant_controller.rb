class Api::V1::ItemMerchantController < ApplicationController
  def show
    if Item.exists?(params[:item_id])
      item = Item.find(params[:item_id])
      render json: MerchantSerializer.new(Merchant.find_by(id: item.merchant_id))
    else
      render json: { errors: 'unable to find' }, status: 404
    end
  end
end