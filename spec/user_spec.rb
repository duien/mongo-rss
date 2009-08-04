# user_spec.rb

require File.join( File.dirname(__FILE__), '../lib/user.rb' )
require File.join( File.dirname(__FILE__), '../lib/item.rb' )

describe User do

  before do
    @user = User.new
  end

  it "should be able to read an item" do
    @user.read( Item.new(), 10 )
  end

  context "with unread items" do
    before do
      @items = [ Item.new(:published_at => Time.at(100), :body => "Card games are good and interesting and I love them."),
                 Item.new(:published_at => Time.at(200), :body => "Politics are boring and I don't want to read about them."),
                 Item.new(:published_at => Time.at(300), :body => "Books are also interesting and I love them too"),
                 Item.new(:published_at => Time.at(400), :body => "Politics are still boring and they suck."),
                 Item.new(:published_at => Time.at(500), :body => "Books and games are still interesting and I super love them.")
               ]

      # TODO: once User#items is removed, refactor this
      @user.items = @items
    end

    it "should have some unread items" do
      @user.unread_items.should_not be nil
    end

    it "should raise an error on a bogus ordering" do
      lambda { @user.unread_items( :order => :bogus ) }.should raise_error
    end

    it "should order the items by oldest" do
      @user.unread_items( :order => :oldest ).should eql @items
    end

    it "should order the items by newest" do
      @user.unread_items( :order => :newest ).should eql @items.reverse
    end

    context "with a hotness signature" do
      before do
        crappy_item = Item.new( :body => "Politics boring blah blah blah lots of words this sucks" )
        groovy_item = Item.new( :body => "Books and card games are interesting I super love them!" )

        @user.read crappy_item, 3     # We blew past this crappy article in 3 seconds
        @user.read groovy_item, 300   # We spent five minutes reading this groovy one
      end

      it "should order the items by hotness" do
        pending "implement hotness signatures" do
          @user.unread_items( :order => :hottest ).should eql [ @items[4], @items[0], @items[2], @items[1], @items[3] ]
        end
      end

    end

  end

end
