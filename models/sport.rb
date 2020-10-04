# frozen_string_literal: true

class Sport < ApplicationRecord
  include Dictionary

  has_many :days
  has_many :stats
end
