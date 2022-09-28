class Reservation < ApplicationRecord
  belongs_to :seance
  belongs_to :user

  validates :status, presence: true
  enum status: { created: 0, confirmed: 1, canceled: 2 }
end
