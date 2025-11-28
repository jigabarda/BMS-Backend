# app/models/user.rb
class User < ApplicationRecord
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :validatable,
         :jwt_authenticatable,
         jwt_revocation_strategy: JwtDenylist

  has_many :devices, dependent: :destroy
  has_many :broadcasts, dependent: :destroy
end
