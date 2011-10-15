require 'rubygems'
require 'uri'
require 'typhoeus'
require 'redis'
require 'fuzz_ball'
require 'sinatra'

module Gitaculous
  autoload :Repo,       'gitaculous/repo'
  autoload :Parser,     'gitaculous/parser'
  autoload :Server,     'gitaculous/server'
end
