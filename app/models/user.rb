class User < ApplicationRecord
  has_secure_password
  validates :roll, presence: true
  validates_acceptance_of :roll, accept: ["admin", "user", "clerk"]
  validates :email, presence: true
  validates :email, :uniqueness => true
  validates :password, presence: true, on: :create
  validates :password, length: { minimum: 8, maximum: 16 }, on: :create
  validates :name, presence: true
  validates :name, length: { minimum: 2 }
end
