# frozen_string_literal: true

# Модуль добавляющий поведение словаря для модели ActiveRecord
module Dictionary
  class NoRecord < RuntimeError; end

  extend ActiveSupport::Concern

  # Методы класса
  module ClassMethods
    def ids_by_codes(*codes)
      by_codes(codes).map(&:id)
    end

    def by_codes(*codes)
      cached.values_at(*[codes].flatten.map(&:to_sym)).compact
    end

    def without_codes(*codes)
      cached.except(*[codes].flatten.map(&:to_sym)).values
    end

    def [](key_s)
      key = key_s.to_sym
      raise NoRecord, "No code #{key.inspect} in table #{name}. Update your database." unless cached.key?(key)

      cached[key]
    end

    # Сбрасываем кэш
    # @return [Nil]
    def flush_cache!
      @cached_at = nil
    end

    def cached
      @cached ||= get_cached_by_codes # First request
      return @cached unless cache_expired?

      @cached = get_cached_by_codes
    end

    def all_cached
      cached_by_id.values
    end

    def cached_by_id
      return @cached_by_id unless cache_expired?

      @cached_by_id =
        select(cached_attributes).order(:id).index_by(&:id).each do |_, v|
          cached_attributes.each { |attr| v.public_send(attr).freeze }
          v.freeze
        end.freeze

      @cached_at = Time.current
      @cached_by_id
    end

    def cached_by_ids(*ids)
      cached_by_id.values_at(*ids.map(&:to_i))
    end

    # TODO: удалить этот метод, так как он относится к уровню View
    # Массив массивов [имя, ID] для постронения селектбоксов
    # @return [Array<Array>]
    # @deprecated
    def for_select(title_attr: :name, except: [])
      cached_by_id.map { |id, d| [d.public_send(title_attr), id] if except.exclude?(id) }.compact
    end

    def cache_expired?
      !(@cached_at && Time.current - @cached_at <= 15.minutes)
    end

    def get_cached_by_codes # rubocop:disable Naming/AccessorMethodName
      cached_by_id.values.select { |row| row.code.present? }.index_by { |row| row.code.to_s.to_sym }.freeze
    end

    # Кешируем только поля id code name и поле name_en если присутсвует
    # @return [Array<Symbol>]
    def cached_attributes
      attributes = %i[id code name]
      attributes.push(:name_en) if attribute_names.include?('name_en')
      attributes.push(:deleted_at) if attribute_names.include?('deleted_at')
      attributes
    end
  end
end
