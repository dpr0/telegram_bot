# frozen_string_literal: true

class Season < ApplicationRecord
  include Dictionary

  has_many :days
  has_many :stats
  has_many :day_players

  def self.days_by_season_id(season_id)
    begin
      Season.cached_by_id[season_id].days.map(&:id)
    rescue
    end
  end

end
