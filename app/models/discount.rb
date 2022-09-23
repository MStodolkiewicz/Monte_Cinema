class Discount < ApplicationRecord
  validates :tickets_needed, :value, presence: true
  validates :tickets_needed, :value, numericality: { only_integer: true, greater_than: 0 }
end
