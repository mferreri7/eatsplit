class RestaurantsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]
  after_action :verify_authorized, except: [:index, :location]
  def index
    if !params[:query].present? && params[:query].nil?
      if session[:location].nil?
        @restaurants = policy_scope(Restaurant)
      else
      @restaurants = policy_scope(Restaurant).near(session[:location], 1)
      end
    elsif !params[:query].present? && params[:query].blank?
      if request.location.city == ""
        @restaurants = policy_scope(Restaurant)
      else
        @restaurants = policy_scope(Restaurant).near(request.location.city, 5)
      end
    else
      @restaurants = policy_scope(filter_by_name)
    end
  end

  def show
    @restaurant = Restaurant.find(params[:id])
    authorize @restaurant
  end

  def location
    session[:location] = params[:data]
    redirect_to root_path
  end

  private

  def filter_by_name
    Restaurant.where("name ILIKE ?", "%#{params[:query]}%")
  end
end
