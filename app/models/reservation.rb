class Reservation < ApplicationRecord
  belongs_to :seance
  belongs_to :user, optional: true

  before_validation :set_user

  validates :status, presence: true
  validates :email, presence: true
  enum status: { reserved: 0, confirmed: 1, canceled: 2 }

  private

  def set_user
    self.user_id = find_user
  end

  def find_user
    User.where(email:).pluck(:id).first
  end
end
