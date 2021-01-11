# frozen_string_literal: true

require 'byebug'
require 'dotenv/load'
require 'telegram/bot'
require_relative 'models/application_record'
require_relative 'models/dictionary'
Dir['models/*.rb'].each { |file| require_relative file }

class Msg
  TBT = Telegram::Bot::Types
  BTN = ->(str) { TBT::KeyboardButton.new(text: str) }
  PHOTO = ->(num) { Faraday::UploadIO.new("images/players/#{Player.photo_nums.include?(num) ? num : 'anonim'}.jpg", 'image/jpeg') }

  def initialize(bot, message)
    Message.create(uid: message.from.id, username: message.from.username, text: message.text)
    @text = message.text.tr('/', '') if message.text
    @num = @text.to_i
    @message = message
    @bot = bot
  end

  def event
    if @num.zero?
      case @text
      when 'start'
        buttons = [[BTN.('break'), BTN.('stop')]]
        markup = TBT::ReplyKeyboardMarkup.new(keyboard: buttons, one_time_keyboard: true, resize_keyboard: true)
        @bot.api.send_message(chat_id: @message.chat.id, text: "Привет #{@message.from.first_name}! Выберите действие:", reply_markup: markup)
      when 'stop'
        kb = TBT::ReplyKeyboardRemove.new(remove_keyboard: true)
        @bot.api.send_message(chat_id: @message.chat.id, text: 'stop', reply_markup: kb)
      else
        # bot.api.send_message(chat_id: @message.chat.id, text: "#{@message.from.first_name}, я не понимаю тебя 🤷‍")
      end
    else
      player = Player.find_by(id: @num)
      if player
        @bot.api.send_photo(chat_id: @message.chat.id, caption: player.print_stat, photo: PHOTO.call(@num))
      else
        @bot.api.send_message(chat_id: @message.chat.id, text: 'Нет такого игрока')
      end
    end
  end
end

Telegram::Bot::Client.run(ENV['BOT_TOKEN'], logger: Logger.new($stderr)) do |bot|
  bot.listen do |message|
    Msg.new(bot, message).event
    bot.logger.info(message) # message.text
  end
end
