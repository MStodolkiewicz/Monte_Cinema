class ApplicationController < ActionController::Base
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from ChangeStatusError, with: :change_status_error

  private

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_back(fallback_location: root_path)
  end

  def change_status_error
    flash[:alert] = "Cannot update status."
    redirect_back(fallback_location: reservations_path)
  end
end
