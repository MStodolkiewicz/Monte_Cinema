class Seance < ApplicationRecord
  belongs_to :hall
  belongs_to :movie

  before_validation :set_end_time

  def set_end_time
    self.end_time = start_time + movie.duration.minutes + 30.minutes
  end

  validate :used?

  validates_associated :hall, :movie

  validates :start_time, :price, :end_time, presence: true
  validates :end_time, comparison: { greater_than: :start_time }
  validates :price, numericality: { greater_than: 0 }
  
  private

  def used?
    unless Seance.where(hall_id: hall_id)
      .where(end_time: start_time..end_time)
      .or(Seance.where(hall_id: hall_id)
      .where(start_time: start_time..end_time))
      .empty?
      errors.add(:start_time, "Hall is used for another seance")
    end
  end
  
end
