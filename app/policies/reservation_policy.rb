class ReservationPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    user.id == @record.user_id || user.manager? || user.admin?
  end

  def create?
    true
  end

  def create_as_guest?
    create?
  end

  def create_as_manager?
    user.manager? || user.admin?
  end

  def new?
    create?
  end

  def destroy?
    user.admin?
  end

  def find_by_user?
    user.manager? || user.admin?
  end

  def find_by_seance?
    user.manager? || user.admin?
  end

  def cancel?
    user.id == @record.user_id || user.manager? || user.admin?
  end

  def confirm?
    user.manager? || user.admin?
  end
end
