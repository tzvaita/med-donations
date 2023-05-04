class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  enum role: [:user, :donor]

  after_initialize :set_default_role, :if => :new_record?

  has_many :donations
  has_many :requests
  has_many :orders

  def set_default_role
    self.role ||= :user
  end
end
