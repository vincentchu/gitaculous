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

		alias :profile :profile_for

    def commits(branch = nil)
			branch = "master" if branch.nil? || (branch.length == 0)
      "#{base_url}/commits/#{branch}"
    end

    def network(type = nil)
      "#{base_url}/network/#{type}"
    end

    def pulls(type = nil)
      "#{base_url}/pulls"
    end

    def forkqueue(type = nil)
      "#{base_url}/forkqueue"
    end

    def issues(type = nil)
      "#{base_url}/issues"
    end

    def milestones(type = nil)
      "#{issues}/milestones"
    end

    def wiki(type = nil)
      "#{base_url}/wiki"
    end

    def graphs(type = "languages")
      "#{base_url}/graphs/#{type}"
    end

    def branch(branch_name)
      "#{branches}/#{branch_name}"
    end

    def branches(type = nil)
     "#{base_url}/branches"
    end

    def compare(*args)
      b1, b2 = (args.length > 1) ? args : args.unshift("master")
      "#{base_url}/compare/#{b1}...#{b2}"
    end

    def tree(branch_name = 'master')
      "#{base_url}/tree/#{branch_name}"
    end

    def blob(file, branch_name = 'master')
      File.join(base_url, file_path_for("blob", branch_name, file))
    end

    def blame(file, branch_name = 'master')
      File.join(base_url, file_path_for("blame", branch_name, file))
    end

    def history(file, branch_name = 'master')
      File.join(base_url, file_path_for("commits", branch_name, file))
    end

    def file_list(branch_name = 'master')
      "#{base_url}/tree-list/#{branch_name}"
    end

    private

    def file_path_for(type, branch_name, file)
      File.join("/", type, branch_name, file)
    end
  end
end
