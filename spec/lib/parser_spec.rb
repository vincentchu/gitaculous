require 'spec_helper'

describe Gitaculous::Parser do
  before(:each) do
    @redis_mock = mock("RedisClient")
    Redis.stub!(:new).and_return(@redis_mock)
  end

  describe "#initialize" do
    before(:each) do
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

  describe "Parsing command strings to redirect URLs" do
    before(:all) do
      @parser   = Gitaculous::Parser.new(:repo => "repo", :user => "user")
      @base_url = @parser.repo.base_url
    end

    it "should handle profile" do
      @parser.parse("profile matz").should == "https://github.com/matz"
    end

    it "should handle commits" do
      @parser.parse("commits").should == "#{@base_url}/commits/master"
    end

    it "should handle commits on a specified branch" do
      @parser.parse("commits foo").should == "#{@base_url}/commits/foo"
    end

    it "should handle network" do
      @parser.parse("network").should == "#{@base_url}/network/"
    end

    it "should handle pulls" do
      @parser.parse("pulls").should == "#{@base_url}/pulls"
    end

    it "should handle forkqueue" do
      @parser.parse("forkqueue").should == "#{@base_url}/forkqueue"
    end

    it "should handle issues" do
      @parser.parse("issues").should == "#{@base_url}/issues"
    end

    it "should handle milestones" do
      @parser.parse("milestones").should == "#{@base_url}/issues/milestones"
    end

    it "should handle wiki" do
      @parser.parse("wiki").should == "#{@base_url}/wiki"
    end

    describe "compare" do
      it "should show compare view against master" do
        @parser.parse("compare foo").should == "#{@base_url}/compare/master...foo"
      end

      it "should compare two arbitrary branches" do
        @parser.parse("compare foo bar").should == "#{@base_url}/compare/foo...bar"
      end
    end

    describe "graphs" do
      before(:all) { @graph_url = "#{@base_url}/graphs" }

      it "should handle languages" do
        @parser.parse("langs").should == "#{@graph_url}/languages"
      end

      it "should handle impact" do
        @parser.parse("impact").should == "#{@graph_url}/impact"
      end

      it "should handle punch" do
        @parser.parse("punch").should == "#{@graph_url}/punchcard"
      end

      it "should handle traffic" do
        @parser.parse("traffic").should == "#{@graph_url}/traffic"
      end
    end
  end
end
