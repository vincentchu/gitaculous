require 'sinatra/base'
require 'cgi'
require 'haml'

module Gitaculous
  class Server < Sinatra::Application

    configure do
      set :cache, {}
      set :views, File.expand_path(File.join(__FILE__, "../../../views"))
    end

    get "/" do
      haml :index
    end

    get "/:user/:repo" do
      redirect handle_query!
    end

    get "/:user/:repo/:query" do
      redirect handle_query!
    end

    private

    def handle_query!
      init_parser!

      redirect_to = begin
        @parser.parse(@query)
      rescue NoMethodError => ex
        url_for_google_query( @query )
      end

      redirect_to
    end

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
