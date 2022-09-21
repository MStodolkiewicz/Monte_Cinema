class MoviePolicy < ApplicationPolicy
  def create?
    manager?
  end

  def update?
    manager?
  end

  def destroy?
    manager?
  end
end
