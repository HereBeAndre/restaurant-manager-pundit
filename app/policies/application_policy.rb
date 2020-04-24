# By default Pundit blocks all actions
class ApplicationPolicy
  # 11) These 2 readers come to rescue. ALWAYS USE THE IN AUTHENTICATION!
  #-> Go back to edit? in RestaurantPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    false
  end
  # 9-a) Second option of point 8: Here I say that the show page is visible if the record exists
  def show?
    scope.where(id: record.id).exists?
  end

  def create?
    false
  end
  # 3) Here Pundit finds a new#method which calls the create?#method
  # and returns false.
  # So my permission will be denied again!
  # That's why I have to over ride this new?#method with
  # a specific one in RestaurantPolicy in order for Pundit to give
  # access to creation of a restaurant
  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.all
    end
  end
end
