# This class inherits from ApplicationPolicy
class RestaurantPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all # 17) Here we have .all
      # We just move it but it does the same purpose (anyone can still view the restaurants)
      # This is the correct way to use Pundit for index (Now I can see all restaurants in browser)

      # 18) What if the owner of McDonalds Italy wants to see all his McDonalds and not McDonalds France?
      # We need to specify it like such:
      # "scope.where(user: user)" # Where the user is the current_user
      # With this line above we can just see all OUR restaurants
    end
    # 19) We keep scope.all for this application. Now that we have the index, we want to actually white-list actions
    # for the users, such as I can see other restaurants but I can't edit edit or delete them. -> Go to index.html.erb
  end
  # 2) At first Pundit can't find a new#method here because it's not present,
  # so it goes in ApplicationPolicy looking for it (because it's the parent)
  def new?
    return true
  end
  # 4) Pundit now finds a new?#method here returning true!
  # Now anyone who has an account can create a restaurant! Both users and admins.
  # We already authenticated with devise so only registered people can do these actions (enforced by line 2 of ApplicationController)

  # 5) I can check in the browser and see the form.
  # If I try to submit (create) the restaurant though I get
  # rejected by Pundit again! Why?
  # because I didn't authorize in the create#method -> (RestaurantsController)

  def create?
    return true
  end
  # 7) Here I set the create?#method to call new?, which returns true
  # I can create a new restaurant in the browser and see it in the terminal.
  # I have another Pundit error in the show#method because I didn't authorize it yet!

  def show?
    return true
  end
  # 9-b) First option of point 8: Here I could authorize and finally able to see the show page of the @restaurant in the browser

  # 10) Now let's say I want to edit a restaurant.
  # I can't authorize anyone because only the owners of the restaurant can update their restaurant! -> Go to ApplicationPolicy
  def edit?
  # 12) user => In this case is current_user (from Devise)
  # record => In this case is @restaurant
  # The logic here is:
  # If I created the restaurant => true (I can edit)
  # Otherwise => false
    record.user == user || user.admin
    # record. user == user => same as below:
    # if record.user == user
    #   true
    # else
    #   false
    # end
  end

  # 31) Now I have to allow admins to edit and update restaurants, so I set in both methods
  # || user.admin => If I open the browser and I login as a user.admin I can now edit/update all the restaurants
  # Same concept could be applied to destroy (See line 79)

  # 13) Now I can edit my restaurant, but still not update it (PATCH)
  def update?
    user_is_owner? || user.admin
  end
  # 13-bis) What I could do here is delete the edit?#method and simply leave update?
  # This is because in ApplicationPolicy edit will call update?,
  # thus if update? is true also edit? is true
  # Same thing could be done with new?# and create?# methods

  # 14) Let's do the index now! To add pundit to index#method we need something different -> Go to #index in RestaurantsController.

  # 23) We might have 2 cases here:
  # a) An admin can destroy || b) The owner can destroy
  # => We do the 2nd case:
  def destroy?
    user_is_owner? || user.admin
  end
  # 24) In the browser we can only destroy the restaurants we own.
  # The code isn't really DRY though, so we can refactor using a private method

  private
  def user_is_owner?
    record.user == user
  end
  # 25) Now I cam simply call this method where we need.
  # We could also apply it in edit? and #update but we'll keep the structure for this guide's sake
end
  # 26) We also want to protect the "New Restaurant" button in index.html.erb -> Go there
