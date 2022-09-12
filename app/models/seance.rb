class Seance < ApplicationRecord
  belongs_to :hall
  belongs_to :movie

  before_validation :end_time

  def end_time
    self.end_time = self.start_time + self.movie.duration.minutes + 30.minutes
  end

  validates_associated :hall, :movie

  validates :start_time, :price, :end_time, presence: true
  validates :end_time, comparison: { greater_than: :start_time }
  validates :price, numericality: { greater_than: 0 }
end
