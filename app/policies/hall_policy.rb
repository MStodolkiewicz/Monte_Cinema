class HallPolicy < ApplicationPolicy
  def index?
    manager? || user.admin?
  end

  def create?
    manager? || user.admin?
  end

  def new?
    create?
  end

  def update?
    manager? || user.admin?
  end

  def edit?
    update?
  end

  def destroy?
    user.admin?
  end
end
