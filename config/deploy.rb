# config valid for current version and patch releases of Capistrano
lock "~> 3.15.0"

server 'krsz.ru', port: 2222, roles: %w(app db web), primary: true

set :application,     'telegram_bot'
set :repo_url,        'git@github.com:dpr0/telegram_bot.git'
set :rbenv_ruby,      '2.6.3'
set :deploy_user,     'deploy'
set :linked_files,    fetch(:linked_files, []).push('.env')
set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto
set :keep_releases,   5
set :user,            'deploy'
set :use_sudo,        false
set :stage,           :production
set :deploy_to,       "/home/#{fetch(:user)}/#{fetch(:application)}"
set :ssh_options, {
    user: fetch(:user),
    keys: %w(~/.ssh/id_rsa),
    forward_agent: true,
    auth_methods: %w(publickey password),
    port: 2222
}

namespace :deploy do
  desc 'deploy bot'
  task :bot do
    on roles(:app) do
      within "#{current_path}" do
        with rails_env: "#{fetch(:stage)}" do
          execute :bundle, 'exec ruby bot.rb'
        end
      end
    end
  end
end
