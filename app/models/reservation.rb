class Reservation < ApplicationRecord
  belongs_to :seance
  belongs_to :user, optional: true

  validates :status, presence: true
  validates :email, presence: true
  validates_format_of :email, with: Devise.email_regexp
  enum status: { reserved: 0, confirmed: 1, canceled: 2 }
end
