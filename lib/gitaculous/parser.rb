module Gitaculous
  class Parser

    SEC_PER_MIN = 60

    attr_reader :config, :repo, :redis, :file_matcher

    def initialize(opts = {})
      @config = opts
      @repo   = Repo.new(:user => config[:user], :repo => config[:repo])
      @redis  = Redis.new (config[:redis] || {})
    end

    def file_matcher
      @file_matcher ||= FuzzBall::Searcher.new( file_list )
    end

    def file_list
      unless @file_list
        redis.exists(redis_file_list_key) ? fetch_file_list_from_redis! : fetch_file_list_from_remote!
      end

      @file_list
    end

    def parse( str )
      args = str.split(/\s+/)
      cmd  = args.shift.downcase.to_sym

      url = case cmd
        when :langs
          repo.graphs(:languages)

        when :impact
          repo.graphs(:impact)

        when :punch
          repo.graphs(:punchcard)

        when :traffic
          repo.graphs(:traffic)

        when :compare
          args = args.first(2)
          repo.compare(*args)

        when :src, :hist, :blame
          handle_file_match(cmd, args.first)

        else
          repo.send(cmd, args.first)
      end

      url
    end

    private

    def handle_file_match(cmd, search_term)
      matches    = file_matcher.search(search_term, :limit => 15, :order => :descending)
      best_match = matches.first[:string]

      case cmd
        when :src
          repo.blob(best_match)

        when :hist
          repo.history(best_match)

        when :blame
          repo.blame(best_match)
      end
    end

    def fetch_file_list_from_redis!
      @file_list = redis.smembers(redis_file_list_key)
    end

    def fetch_file_list_from_remote!
      response = Typhoeus::Request.get(repo.file_list, :user_agent => "Gitaculous - http://github.com/vincentchu/gitaculous")
      @file_list = response.body.split("\n")

      @file_list.each do |file|
        redis.sadd(redis_file_list_key, file)
      end

      redis.expire(redis_file_list_key, 10 * SEC_PER_MIN)
    end

    def redis_file_list_key
      ["filelist", repo.repo, repo.user].join(":")
    end

  end
end
