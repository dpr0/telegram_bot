# frozen_string_literal: true

class Game < ApplicationRecord
  has_many :goals
  belongs_to :day
end
