class DishesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]
  def index
    session[:order_ids] = []
    @restaurant = Restaurant.find(params[:restaurant_id])
    @dishes = policy_scope(@restaurant.dishes)
    @table = Table.find(params[:table_id]) if params[:table_id].present?
  end
end
