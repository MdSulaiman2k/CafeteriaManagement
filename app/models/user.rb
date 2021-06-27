class User < ApplicationRecord
  has_secure_password
  validates :roll, presence: true
  validates_acceptance_of :roll, accept: ["admin", "user", "clerk"]
  validates :email, presence: true
  validates :email, :uniqueness => true
  validates :password, presence: true
  validates :password, length: { minimum: 8, maximum: 16 }
  validates :name, presence: true
  validates :name, length: { minimum: 2 }
end
