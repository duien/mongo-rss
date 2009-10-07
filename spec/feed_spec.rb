require File.join( File.dirname(__FILE__), '../lib/feed.rb' )
require File.join( File.dirname(__FILE__), '../lib/item.rb' )

describe Feed do

  # I need to get the gem for mocking Net::HTTP calls before I can do much
  # here.  (I can't do that now because I'm working offline.)

  before do 
    @feed = Feed.new
    # TODO: fill in some details here
  end

  context "that has never been updated" do

    it "should not have any items" do
      @feed.items.should be_empty
    end

    it "should grab a bunch of items on the first update" do
      pending "mock out some HTTP responses" do
        @feed.items.should_not be_empty
        # probably ought to check that it's some particular size, really
      end
    end

  end

  context "that has been updated" do
    before do
      #@feed.update!
    end

    it "should have some items" do
      pending "mock out some HTTP responses" do
        @feed.items.should_not be_empty
      end
    end

    it "should update with only the new items" do
      pending "mock out some HTTP responses" do
        old_items = @feed.items
        @feed.update!
        @feed.items.should_not contain_any(old_items)
      end
    end

  end

end
