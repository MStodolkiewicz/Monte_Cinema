class DiscountPolicy < ApplicationPolicy
  def index?
    user.manager? || user.admin?
  end

  def create?
    user.manager? || user.admin?
  end

  def new?
    create?
  end

  def update?
    user.manager? || user.admin?
  end

  def edit?
    update?
  end

  def destroy?
    user.admin?
  end
end
