# frozen_string_literal: true

class Team < ApplicationRecord
  include Dictionary

  has_many :day_players
end
