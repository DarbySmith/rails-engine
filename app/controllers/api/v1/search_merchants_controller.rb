class Api::V1::SearchMerchantsController < ApplicationController
  def index
    render json: MerchantSerializer.new(Merchant.search(params[:name]))
  end
end