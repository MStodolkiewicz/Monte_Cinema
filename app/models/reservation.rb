class Reservation < ApplicationRecord
  belongs_to :seance
  belongs_to :user

  validates :status, presence: true
  enum :status, %i[created confirmed canceled]
end
