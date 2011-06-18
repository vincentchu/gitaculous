module Gitaculous
  class Repo
   
   attr_reader :repo, :user, :base_url
   
   def initialize(opts = {})
    @repo = opts[:repo]
    @user = opts[:user]
    @base_url = "https://github.com/#{user}/#{repo}"
   end
     
  end
end