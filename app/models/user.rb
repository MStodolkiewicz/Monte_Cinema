class User < ApplicationRecord
  has_many :reservations, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  enum role: %i[user manager admin]

  validate :validate_password_length

  private

  def validate_password_length
    return unless password.nil? || password.bytesize > 72

    errors.add(:password, 'Password is too long')
  end
end
