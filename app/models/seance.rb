class Seance < ApplicationRecord
  belongs_to :hall
  belongs_to :movie

  validates_associated :hall, :movie
  before_validation :set_end_time, unless: :start_nil?

  validate :used?
  validates :start_time, presence: true
  validates :end_time, presence: true, comparison: { greater_than: :start_time }
  validates :price, presence: true, numericality: { greater_than: 0 }

  private

  def start_nil?
    start_time.nil?
  end

  def set_end_time
    self.end_time = start_time + movie.duration.minutes + TIME_OF_ADS
  end

  def used?
    return if scence_within_given_time_and_hall_exist?

    errors.add(:start_time, "Hall is used for another seance")
  end

  def scence_within_given_time_and_hall_exist?
    Seance
      .where(hall_id:)
      .where(end_time: start_time..end_time)
      .or(Seance.where(hall_id:)
      .where(start_time: start_time..end_time))
      .empty?
  end
end
