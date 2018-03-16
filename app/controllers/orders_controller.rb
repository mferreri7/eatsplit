class OrdersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show, :create, :checkout]

  def show
    @order = Order.where(status: 'paid').find(params[:id])
  end

  def create
    @dish = Dish.find(params[:dish_id])
    @order = Order.create!(dish: @dish)
    authorize @order
    session[:order_ids] = [] if session[:order_ids].blank?
    session[:order_ids] << @order.id
    render json: {success: true}
  end

  def checkout
    @orders = session[:order_ids].map do |order_id|
      Order.find(order_id)
    end
    @orders.each do |order|
      authorize order
    end
    authorize Order.first if @orders.empty?
  end
end
