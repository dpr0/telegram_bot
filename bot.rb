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
    @chat_id = message.chat.id if message.chat
    Message.create(
      uid:               message.from.id,
      username:          message.from.username,
      text:              message.text,
      message_id:        message.message_id,
      chat_id:           @chat_id,
      date:              message.date,
      reply_message_id: (message.reply_to_message.message_id if message.reply_to_message)
    )
    @text = message.text.tr('/', '') if message.text
    a = @text.split
    @num = a.first.to_i if a.size == 1 && a.first.to_i != 0
    @message = message
    @bot = bot
  end

  def event
    if @num
      player = Player.find_by(id: @num)
      if player
        @bot.api.send_photo(chat_id: @message.chat.id, caption: player.print_stat, photo: PHOTO.call(@num))
      else
        @bot.api.send_message(chat_id: @message.chat.id, text: 'Нет такого игрока')
      end
    else
      case @text
      when 'start'
        buttons = [[BTN.('break'), BTN.('stop')]]
        markup = TBT::ReplyKeyboardMarkup.new(keyboard: buttons, one_time_keyboard: true, resize_keyboard: true)
        @bot.api.send_message(chat_id: @chat_id, text: "Привет #{@message.from.first_name}! Выберите действие:", reply_markup: markup)
      when 'stop'
        kb = TBT::ReplyKeyboardRemove.new(remove_keyboard: true)
        @bot.api.send_message(chat_id: @chat_id, text: 'stop', reply_markup: kb)
      else
        # bot.api.send_message(chat_id: @message.chat.id, text: "#{@message.from.first_name}, я не понимаю тебя 🤷‍")
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
