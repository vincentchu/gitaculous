require 'spec_helper'

describe Gitaculous::Parser do

  describe "#initialize" do
    before(:each) do
      @redis_mock = mock("RedisClient")
      Redis.stub!(:new).and_return(@redis_mock)
      @parser = Gitaculous::Parser.new(:repo => "repo", :user => "user")
    end

    it "should set the config instance variable" do
      @parser.config.should == {:repo => "repo", :user => "user"}
    end

    it "should set its Repo object" do
      @parser.repo.class.should == Gitaculous::Repo
      @parser.repo.user.should  == "user"
      @parser.repo.repo.should  == "repo"
    end

    it "should make a connection to redis" do
      @parser.redis.class.should == RSpec::Mocks::Mock
    end

    describe "Fetching the file list" do

      before(:each) do
        @file_list_str = "README.md\nlib/gitaculous.rb\n"
        @file_list_arr = @file_list_str.split("\n")
        @mock_response = mock("thyphoeus_mock_response")
        @mock_response.stub!(:body).and_return(@file_list_str)
      end

      after(:each) { @parser.file_list.should == @file_list_arr }

      it "should fetch a file list from github if not in redis cache" do
        @redis_mock.should_receive(:exists).once.with("filelist:repo:user").and_return(false)
        Typhoeus::Request.should_receive(:get).once.with(
          "https://github.com/user/repo/tree-list/master", :user_agent => "Gitaculous - http://github.com/vincentchu/gitaculous"
        ).and_return(@mock_response)
        @redis_mock.should_receive(:sadd).exactly(2).times
        @redis_mock.should_receive(:expire).once.with("filelist:repo:user", 600)
      end

      it "should fetch list from redis if it exists" do
        @redis_mock.should_receive(:exists).once.with("filelist:repo:user").and_return(true)
        @redis_mock.should_receive(:smembers).once.with("filelist:repo:user").and_return(@file_list_arr)
      end
    end
  end
end
