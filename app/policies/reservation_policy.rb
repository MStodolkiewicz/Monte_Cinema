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

  def new?
    create?
  end

  def update?
    user.id == @record.user_id || user.manager? || user.admin?
  end

  def edit?
    update?
  end

  def destroy?
    user.admin?
  end

  def find_reservations_by_user?
    user.manager? || user.admin?
  end

  def find_reservations_by_seance?
    user.manager? || user.admin?
  end

  def cancel_reservation?
    @record.status == "reserved" && (user.id == @record.user_id || user.manager?) || user.admin?
  end

  def confirm_reservation?
    @record.status == "reserved" && user.manager? || user.admin?
  end
end
