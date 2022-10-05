class ReservationPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    user.id == @record.user_id || user.manager? || user.admin?
  end

  def create_for_other_user?
    user.manager? || user.admin?
  end

  def create_when_started?
    user.manager? || user.admin?
  end

  def create?
    true
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
