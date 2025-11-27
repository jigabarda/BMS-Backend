# app/models/user.rb
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist # we'll create revoke model

  has_many :broadcasts, dependent: :nullify
  has_many :devices, dependent: :destroy
end
