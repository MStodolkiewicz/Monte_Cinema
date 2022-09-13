class Seance < ApplicationRecord
  belongs_to :hall
  belongs_to :movie

  before_validation :end_time

  def end_time
    self.end_time = self.start_time + self.movie.duration.minutes + 30.minutes
  end

  validate :is_used

  def is_used
    Seance.where(hall_id: self.hall_id).each do |item|
      if self.start_time.between?(item.start_time, item.end_time) ||
          self.end_time.between?(item.start_time, item.end_time)
        errors.add(:start_time, "Hall is used for another seance")
        break
      end
    end
  end

  validates_associated :hall, :movie

  validates :start_time, :price, :end_time, presence: true
  validates :end_time, comparison: { greater_than: :start_time }
  validates :price, numericality: { greater_than: 0 }
end
