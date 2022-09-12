class Hall < ApplicationRecord
    has_many :seances

    validates :capacity, :number, presence: true 
    validates :capacity, :number, numericality: {only_integer: true, greater_than: 0 }
    validates :number, uniqueness: true
end
