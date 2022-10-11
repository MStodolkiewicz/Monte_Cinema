class User < ApplicationRecord
  include DeviseTokenAuth::Concerns::User
  has_many :reservations, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  enum role: { user: 0, manager: 1, admin: 2 }

  validate :validate_password_length

  private

  def validate_password_length
    return unless password.nil? || password.bytesize > 72

    errors.add(:password, 'is too long')
  end
end
