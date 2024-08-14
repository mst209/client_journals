class Provider < ApplicationRecord
  has_many :subscriptions
  has_many :clients, through: :subscriptions
end
