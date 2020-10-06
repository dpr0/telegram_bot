# frozen_string_literal: true

require 'byebug'
require 'dotenv/load'
require 'telegram/bot'
require_relative 'models/application_record'
require_relative 'models/dictionary'
Dir['models/*.rb'].each { |file| require_relative file }

TBT = Telegram::Bot::Types
BTN = lambda { |str| TBT::KeyboardButton.new(text: str) }

Telegram::Bot::Client.run(ENV['BOT_TOKEN'], logger: Logger.new($stderr)) do |bot|
  bot.listen do |message|
    Message.create(uid: message.from.id, username: message.from.username, text: message.text)
    bot.logger.info(message.text)
    text = message.text.tr('/', '').to_i if message.text
    num = text.to_i
    if num != 0
      bot.api.send_message(chat_id: message.chat.id, text: Player.print_stat(num))
    else
      case text
      when 'start'
        buttons = [[BTN.call('break'), BTN.call('stop')]]
        markup = TBT::ReplyKeyboardMarkup.new(keyboard: buttons, one_time_keyboard: true, resize_keyboard: true)
        bot.api.send_message(chat_id: message.chat.id, text: "Привет #{message.from.first_name}! Выберите действие:", reply_markup: markup)
      when 'stop'
        kb = TBT::ReplyKeyboardRemove.new(remove_keyboard: true)
        bot.api.send_message(chat_id: message.chat.id, text: 'stop', reply_markup: kb)
      else
        # bot.api.send_message(chat_id: message.chat.id, text: "#{message.from.first_name}, я не понимаю тебя 🤷‍")
      end
    end
  end
end
