class User < ApplicationRecord
  has_secure_password
  has_many :addresses, dependent: :destroy
  has_many :cart_items, dependent: :destroy
  has_many :orders, dependent: :destroy
  validates :roll, presence: true
  validates_acceptance_of :roll, accept: ["admin", "user", "clerk"]
  validates :email, presence: true
  validates :email, :uniqueness => true
  validates :password, presence: true
  validates :password, length: { minimum: 8, maximum: 16 }
  validates :phonenumber, presence: true
  validates :phonenumber, length: { minimum: 10, maximum: 13 }
  validates :name, presence: true
  validates :name, length: { minimum: 2 }
end
