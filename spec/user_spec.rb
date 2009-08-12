# user_spec.rb

require File.join( File.dirname(__FILE__), '../lib/user.rb' )
require File.join( File.dirname(__FILE__), '../lib/item.rb' )
require File.join( File.dirname(__FILE__), '../lib/hotness_signature.rb' )

describe User do

  before do
    @user = User.new
  end

  it "should have a hotness signature" do
    @user.hotness_signature.should be_an_instance_of HotnessSignature
  end

  it "should be able to read an item" do
    @user.read( Item.new( :body => "Some text!" ), 10 )
  end

  context "with unread items" do
    before do
      @items = [ Item.new(:published_at => Time.at(100), :body => "Card games are interesting."),
                 Item.new(:published_at => Time.at(200), :body => "Politics are boring."),
                 Item.new(:published_at => Time.at(300), :body => "Books are also interesting."),
                 Item.new(:published_at => Time.at(400), :body => "Politics are still boring and they suck."),
                 Item.new(:published_at => Time.at(500), :body => "Books and games are still interesting and I love them.")
               ]

      # TODO: once User#items is removed, refactor this
      @user.items = @items
      @user.hotness_signature = HotnessSignature.new
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

    context "with a trained hotness signature" do
      before do
        crappy_item = Item.new( :body => "Politics boring sucks" )
        groovy_item = Item.new( :body => "Books books card games games interesting love" )

        @user.read crappy_item, 3     # We blew past this crappy article in 3 seconds
        @user.read groovy_item, 300   # We spent five minutes reading this groovy one
      end

      it "should order the items by hotness" do
        @user.unread_items( :order => :hottest ).should eql [ @items[4], @items[0], @items[2], @items[1], @items[3] ]
      end

    end

  end

end
