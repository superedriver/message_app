require 'sinatra'
require 'sinatra/activerecord'
require 'pry'
require 'haml'
require 'securerandom'
require 'aescrypt'
# require 'sinatra/respond_to'
#
# Sinatra::Application.register Sinatra::RespondTo

require_relative 'models/message'
require_relative 'models/option'
require_relative 'controllers/messages'
require_relative 'controllers/home'
