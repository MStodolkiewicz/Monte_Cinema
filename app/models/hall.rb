class Hall < ApplicationRecord
    has_many :seances, dependent: :destroy

    validates :capacity, :name, presence: true 
    validates :capacity, numericality: {only_integer: true, greater_than: 0 }
    validates :name, uniqueness: true
end
