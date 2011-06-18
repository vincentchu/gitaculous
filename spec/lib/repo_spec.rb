require 'spec_helper'

describe Gitaculous::Repo do

  before(:all) do
    @repo     = Gitaculous::Repo.new(:user => "user", :repo => "repo")
    @base_url = "https://github.com/user/repo"
  end

  describe "#initialize" do
    it "should assign the right values to instance variables" do
      @repo.user.should == "user"
      @repo.repo.should == "repo"
    end

    it "should have a base URL" do
      @repo.base_url.should == @base_url
    end
  end

  describe "#profile_for" do
    it "should return the URL of a user" do
      @repo.profile_for("matz").should == "https://github.com/matz"
    end
  end

  describe "#commits" do
    it "should return the URL for master" do
      @repo.commits.should == "#{@base_url}/commits/master"
    end
    
    it "should return the URL for any branch" do
      @repo.commits("foo").should == "#{@base_url}/commits/foo"
    end
  end
  
  describe "#network" do
    it "should return the URL for the network" do
      @repo.network.should == "#{@base_url}/network/"
    end
  end
  
  describe "#pulls" do
    it "should return the URL for pull requests" do
      @repo.pulls.should == "#{@base_url}/pulls"
    end
  end
  
  describe "#forkqueue" do
    it "should return the URL" do
      @repo.forkqueue.should == "#{@base_url}/forkqueue"
    end
  end
  
  describe "#issues" do
    it "should return the URL" do
      @repo.issues.should == "#{@base_url}/issues"
    end
    
    it "should return the URL for milestones" do
      @repo.milestones.should == "#{@base_url}/issues/milestones"
    end
  end
  
  describe "#wiki" do
    it "should return the URL" do
      @repo.wiki.should == "#{@base_url}/wiki"
    end
  end
  
  describe "#graphs" do
    it "should return the URL" do
      @repo.graphs.should == "#{@base_url}/graphs/languages"
    end
    
    it "should return URL for impact" do
      @repo.graphs(:impact).should == "#{@base_url}/graphs/impact"
    end
    
    it "should return URL for punchcard" do
      @repo.graphs(:punchcard).should == "#{@base_url}/graphs/punchcard"
    end
    
    it "should return URL for traffic" do
      @repo.graphs(:traffic).should == "#{@base_url}/graphs/traffic"
    end
  end
  
  describe "#compare view" do
    it "should return the URL (default comparison base is master)" do
      @repo.compare("foo").should == "#{@base_url}/compare/master...foo"
    end
    
    it "should return the URL for comparing two arbitrary branches" do
      @repo.compare("foo", "bar").should == "#{@base_url}/compare/foo...bar"
    end
  end
  
  describe "#branches" do
    it "should return the URL" do
      @repo.branches.should == "#{@base_url}/branches"
    end
  end
  
  describe "#branch" do
    it "should return the URL" do
      @repo.branch("foo").should == "#{@repo.branches}/foo"
    end
  end
  
  describe "#tree" do
    it "should return the URL (default of master)" do
      @repo.tree("foo").should == "#{@base_url}/tree/foo"
    end
  end
  
  describe "#blame" do
    it "should return the URL" do
      
    end
  end
  
  describe "#history" do
  end
end