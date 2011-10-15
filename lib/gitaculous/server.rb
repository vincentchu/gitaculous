require 'sinatra/base'
require 'cgi'
module Gitaculous
  class Server < Sinatra::Application

    configure do
      set :cache, {}
    end

    get "/" do
      'This is root'
    end

    get "/:user/:repo/:query" do

      init_parser!

      redirect_to = begin
        @parser.parse(@query)
      rescue NoMethodError => ex
        url_for_google_query( @query )
      end

      redirect redirect_to
    end

    private

    def init_parser!

      @user  = params[:user]
      @repo  = params[:repo]
      @query = params[:query]

      @cache_key = [@user, @repo].join("::")
      @parser = settings.cache[@cache_key]

      unless @parser
        @parser = Gitaculous::Parser.new(:repo => @repo, :user => @user)
        settings.cache[@cache_key] = @parser
      end
    end

    def url_for_google_query( query )
      "http://www.google.com/search?q=#{CGI.escape(query)}"
    end

  end
end
