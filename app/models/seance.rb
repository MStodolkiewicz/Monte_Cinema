class Seance < ApplicationRecord
  belongs_to :hall
  belongs_to :movie

  validates_associated :hall, :movie

  validates :start_time, :price, presence: true
  #validates :end_time, presence: true, comparison: { less_than: :start_time }
  #After implementing end_time based on start_time and lenght of the Movie
  validates :price, numericality: { greater_than: 0 }
end
