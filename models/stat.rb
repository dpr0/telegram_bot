# frozen_string_literal: true

class Stat < ApplicationRecord
  include Dictionary

  belongs_to :sport
  belongs_to :season
  belongs_to :player
end
