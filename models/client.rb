class Client < ApplicationRecord
  has_many :subscriptions
  has_many :providers, through: :subscriptions
end
