require 'spec_helper'
require 'caller_id'

describe CallerId do
  let(:white_house_num) { "2024561414" }
  let(:white_house_lookup_response) { {:cnam => "WHITE HOUSE SWI", :number => white_house_num} }
  let(:kevin_brower) { "(510) 883-1085"}
  let(:not_found) { "5034871414" }
  let(:now) { Time.now }
  describe "#lookup" do
    use_vcr_cassette
    it "returns name" do
      CallerId::ReversePhoneLookup.new(white_house_num).lookup.should == white_house_lookup_response
    end
    it "ignores leading 1" do
      CallerId::ReversePhoneLookup.new("1#{white_house_num}").lookup.should == white_house_lookup_response
    end
    it "ignores anything other than numbers" do
      CallerId::ReversePhoneLookup.new("+1(#{white_house_num})...").lookup.should == white_house_lookup_response
    end
  end
  describe "#lookup uncached number" do
    use_vcr_cassette
    it "returns retry" do
      Timecop.freeze(now) do
        CallerId::ReversePhoneLookup.new(kevin_brower).lookup.should == {:retry => true, :now => now}
      end
    end
  end
  describe "#lookup unlisted number" do
    use_vcr_cassette
    it "returns not found" do
      CallerId::ReversePhoneLookup.new(not_found).lookup.should == {:not_found => true}
    end
  end
  describe "#lookup invalid number" do
    it "raises an error before even trying the lookup" do
      expect { CallerId::ReversePhoneLookup.new("foo") }.to raise_error
    end
  end
end
