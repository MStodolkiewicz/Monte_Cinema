class Movie < ApplicationRecord
  has_many :seances, dependent: :destroy

  validates :name, presence: true
  validates :duration, presence: true, numericality: { only_integer: true, greater_than: 0 }
end
