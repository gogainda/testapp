require 'socket'
require 'json'
require_relative 'run_it'

describe Server do
  it "if empty text block then result array sould be empty" do
    Server.frequently_words(5, "").should == []
  end
  it "should be correct2" do
    Server.frequently_words(5, "ab").should == [["ab", 1]]
  end

  it "should be correct3" do
    Server.frequently_words(5, "ab bc cd de ef fg fg fg fg").should == [["fg", 4], ["de", 1], ["cd", 1], ["bc", 1], ["ef", 1]]
  end
  it "should be 10 elements in the result array" do
   Server.frequently_words(5, "ab bc cd de ef fg fg fg fg").flatten.size.should == 10
  end
end