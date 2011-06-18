module Gitaculous
  class Repo
    
    GITHUB_HOST = "https://github.com"
   
   attr_reader :repo, :user, :base_url
   
   def initialize(opts = {})
    @repo = opts[:repo]
    @user = opts[:user]
    @base_url = "#{GITHUB_HOST}/#{user}/#{repo}"
   end
     
   def profile_for(user)
     URI.join(GITHUB_HOST, user).to_s
   end
   
   def commits(branch = "master")
     "#{base_url}/commits/#{branch}"
   end
   
   def network(type = nil)
     "#{base_url}/network/#{type}"
   end
   
   def pulls
     "#{base_url}/pulls"
   end
   
   def forkqueue
     "#{base_url}/forkqueue"
   end
   
   def issues
     "#{base_url}/issues"
   end
   
   def milestones
     "#{issues}/milestones"
   end
   
   def wiki
     "#{base_url}/wiki"
   end
   
   def graphs(type = "languages")
     "#{base_url}/graphs/#{type}"
   end

   def branch(branch_name)
     "#{branches}/#{branch_name}"
   end

   def branches
    "#{base_url}/branches"
   end
        
    def compare(*args)      
      b1, b2 = (args.length > 1) ? args : args.unshift("master")
      "#{base_url}/compare/#{b1}...#{b2}"
    end
  end
end