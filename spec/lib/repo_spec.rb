require 'spec_helper'

describe Gitaculous::Repo do

  before(:all) do
    @repo = Gitaculous::Repo.new(:user => "user", :repo => "repo")
  end

  it "should assign the right values to instance variables" do
    @repo.user.should == "user"
    @repo.repo.should == "repo"
  end

  it "should have a base URL" do
    @repo.base_url.should == "https://github.com/user/repo"
  end

  describe "#user" do
  end

  describe "#commits" do
  end
  
  describe "#network" do
  end
  
  describe "#pulls" do
  end
  
  describe "#forkqueue" do
  end
  
  describe "#issues" do
  end
  
  describe "#wiki" do
  end
  
  describe "#graphs" do
  end


end