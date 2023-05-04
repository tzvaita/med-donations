class Request < ApplicationRecord
  has_many :orders
  belongs_to :user
  enum role: [:active, :pending, :done]

end
