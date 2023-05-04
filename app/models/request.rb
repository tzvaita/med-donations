class Request < ApplicationRecord
  has_many :orders
  belongs_to :user
  enum role: [:active, :pending, :done]

  scope :still_active, -> { where(role: 0) }

end
