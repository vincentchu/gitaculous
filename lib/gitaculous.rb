require 'rubygems'
require 'uri'
require 'typhoeus'
require 'redis'

module Gitaculous
  
  autoload :Repo,   'gitaculous/repo'
  autoload :Parser, 'gitaculous/parser'
  
end