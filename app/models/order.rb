class Order < ApplicationRecord
  belongs_to :user
  belongs_to :address, optional: true
  has_many :order_items, dependent: :destroy
  validates_acceptance_of :status, accept: ["pending", "delivered", "cancel"]

  def frombetweendates
  end
end
