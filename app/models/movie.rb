class Movie < ApplicationRecord
    has_many :seances, dependent: :destroy

    validates :name, :duration, presence: true 
    validates :duration, numericality: {only_integer: true, greater_than: 0 }
end
