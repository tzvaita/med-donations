class Request < ApplicationRecord
  has_many :orders
  has_many :payments
  belongs_to :user
  enum role: [:active, :pending, :done]

end
