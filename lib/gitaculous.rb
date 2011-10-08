require 'rubygems'
require 'uri'
require 'typhoeus'
require 'redis'
require 'fuzz_ball'

module Gitaculous
  autoload :Repo,       'gitaculous/repo'
  autoload :Parser,     'gitaculous/parser'
end
