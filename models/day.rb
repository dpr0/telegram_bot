# frozen_string_literal: true

class Day < ApplicationRecord
  has_many :games
  has_many :day_players
  belongs_to :sport
  belongs_to :season
end
