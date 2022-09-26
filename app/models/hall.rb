class Hall < ApplicationRecord
  has_many :seances, dependent: :destroy

  validates :capacity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :name, presence: true, uniqueness: true
end
