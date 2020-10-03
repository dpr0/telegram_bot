# frozen_string_literal: true

require 'byebug'
require 'dotenv/load'
require 'telegram/bot'

TBT = Telegram::Bot::Types
def button(string)
  TBT::KeyboardButton.new(text: string)
end

Telegram::Bot::Client.run(ENV['BOT_TOKEN'], logger: Logger.new($stderr)) do |bot|
  bot.listen do |message|
    bot.logger.info(message.text)
    case message.text
    when 'start'
      buttons = [[button('hello'), button('stop')]]
      markup = TBT::ReplyKeyboardMarkup.new(keyboard: buttons, one_time_keyboard: true, resize_keyboard: true)
      bot.api.send_message(chat_id: message.chat.id, text: "Привет #{message.from.first_name}! Выберите действие:", reply_markup: markup)
    when 'hello'
      bot.api.send_message(chat_id: message.chat.id, text: 'hello')
    when 'stop'
      kb = TBT::ReplyKeyboardRemove.new(remove_keyboard: true)
      bot.api.send_message(chat_id: message.chat.id, text: 'stop', reply_markup: kb)
    else
      bot.api.send_message(chat_id: message.chat.id, text: "#{message.from.first_name}, я не понимаю тебя 🤷‍")
    end
  end
end
