# frozen_string_literal: true

class Player < ApplicationRecord
  belongs_to :team
  has_one    :role
  has_many   :goals
  has_many   :day_players
  has_many   :stats

  LAST_SEASON_ID = Season.last.id

  def goals_by_season(season_id)
    goals.where(season_id: season_id)
  end

  def day_players_by_season(season_id)
    day_players.where(season_id: season_id)
  end

  def dp_tally(dp)
    dp.map(&:team_id).group_by { |x| x }.transform_values(&:size)
  end

  def text_phone
    # phone ? "8-#{phone[0..2]}-#{phone[3..5]}-#{phone[6..7]}-#{phone[8..9]}" : '-'
    phone ? "8-#{phone[0..2]}-xxx-xx-#{phone[8..9]}" : '-'
  end

  def with_initial
    "#{name} #{(lastname.first + '.') if lastname.present?}"
  end

  def short_name
    "#{name} #{lastname if lastname.present?}"
  end

  def full_name
    "#{(lastname + ' ') if lastname.present?}#{name} #{middlename if middlename.present?}"
  end

  def self.cached_by_id
    @players ||= all.group_by(&:id)
  end

  def self.print_stat(num)
    player = find_by(id: num)
    assist_count = Goal.where(season_id: LAST_SEASON_ID, assist_player_id: player.id).count
    return 'Нет такого игрока' unless player

    stat = player.stats.where(season_id: LAST_SEASON_ID).first
    rate = player.day_players.last
    "#{player.short_name}: https://football.krsz.ru/players/#{player.id}
        рост: #{player.height} / вес: #{player.weight}
        дней: #{stat.days} / игр: #{stat.games}
        победы: #{stat.win} / ничьи: #{stat.draw} / поражения: #{stat.lose}
        рейтинг ЭЛО: #{rate.rate} / коэффициент полезности: #{rate.kp}
        голы: #{player.goals_by_season(LAST_SEASON_ID).count} / голевые передачи: #{assist_count}"
  end
end
