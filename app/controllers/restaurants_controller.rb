class RestaurantsController < ApplicationController
  before_action :set_restaurant, only: [:show, :edit, :update, :destroy]

  def index
    # 15) @restaurants = Restaurant.all => We can't use this for Pundit in #index
    @restaurants = policy_scope(Restaurant) # But this!
    # 16) This line above calls the resolve#method inside Scope class in RestaurantPolicy -> Go to RestaurantPolicy
  end

  def show
  end

  def new
    @restaurant = Restaurant.new
    authorize @restaurant
    # 1) When I call authorize, Pundit looks for a policy inside the Class of our instance,
    # in this case Restaurant class because of @restaurant -> goes to RestaurantPolicy and looks
    # for a new#method, which is the equivalent of the method I'm in right now
  end

  def edit
  end

  def create
    @restaurant = Restaurant.new(restaurant_params)
    @restaurant.user = current_user
    # 6) Need to authorize the restaurant here! But I also need to over ride the create?#method in RestaurantPolicy
    authorize @restaurant
    if @restaurant.save
      redirect_to @restaurant, notice: 'Restaurant was successfully created.'
    else
      render :new
    end
  end

  def update
    if @restaurant.update(restaurant_params)
      redirect_to @restaurant, notice: 'Restaurant was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @restaurant.destroy
    redirect_to restaurants_url, notice: 'Restaurant was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_restaurant
      @restaurant = Restaurant.find(params[:id])
      # 8) I can authorize the show#method from here since set_restaurant
      # will be executed in before_action, before the show#method.
      # From here I could authorize in RestaurantPolicy like I did previously or
      # allow the show page to be seen by everyone -> I choose the 2nd option and go to ApplicationPolicy
      authorize @restaurant
    end

    # Only allow a list of trusted parameters through.
    def restaurant_params
      params.require(:restaurant).permit(:name, :user_id)
    end
end
