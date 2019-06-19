require 'json'
require 'byebug'
require 'restclient'
require 'dotenv/load'
require 'yaml'
require 'telegram/bot'

Telegram::Bot.configure do |config|
  config.ssl_opts = { verify: false }
  config.proxy_opts = { uri: "#{ENV['PROXY_SERVER']}:#{ENV['PROXY_PORT']}", socks: true,
                        user: ENV['PROXY_USERNAME'], password: ENV['PROXY_PASSWORD'] }
end

def button(string)
  Telegram::Bot::Types::KeyboardButton.new(text: string)
end

Telegram::Bot::Client.run(ENV['BOT_TOKEN']) do |bot|

  bot.listen do |message|
    case message.text
    when '/start'
      puts 'start'
      buttons = [[button('/hello'), button('/break')]]
      markup = Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: buttons, one_time_keyboard: true, resize_keyboard: true)
      bot.api.send_message(chat_id: message.chat.id, text: "Привет #{message.from.first_name}! Выберите действие:", reply_markup: markup)
    when '/hello'
      puts 'hello'
      bot.api.send_message(chat_id: message.chat.id, text: 'hello')
    when '/break'
      puts 'break'
      bot.api.send_message(chat_id: message.chat.id, text: 'break')
      break
    else
      puts 'else'
      bot.api.send_message(chat_id: message.chat.id, text: 'I don\'t understand you :(')
    end
  end
end
