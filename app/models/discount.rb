class Discount < ApplicationRecord
  validates :tickets_needed, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :value, presence: true, numericality: { only_integer: true, greater_than: 0 }
end
