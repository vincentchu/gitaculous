module Gitaculous
  class Parser
    
    SEC_PER_MIN = 60
    
    attr_reader :config, :repo, :redis
    
    def initialize(opts = {})
      @config = opts
      @repo   = Repo.new(:user => config[:user], :repo => config[:repo])
      @redis  = Redis.new (config[:redis] || {})
    end
    
    def file_list
      unless @file_list
        redis.exists(redis_file_list_key) ? fetch_file_list_from_redis! : fetch_file_list_from_remote!
      end
      
      @file_list      
    end
    
    private
    
    def fetch_file_list_from_redis!
      puts "Getting file list from redis ... "      
      @file_list = redis.smembers(redis_file_list_key)      
    end
    
    def fetch_file_list_from_remote!
      puts "Making request ... "
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