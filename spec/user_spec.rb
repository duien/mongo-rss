# user_spec.rb

require File.join( File.dirname(__FILE__), '../lib/user.rb' )

describe User do

  before(:all) do
    @user = User.new
  end

  context "with unread items" do
    before(:each) do
      @user.unread_items = [ Item.new("Card games are good and interesting and I love them."),
                             Item.new("Politics are boring and I don't want to read about them."),
                             Item.new("Books are also interesting and I love them too"),
                             Item.new("Politics are still boring and they suck."),
                             Item.new("Books and games are still interesting and I super love them.")
                           ]
    end

    it "should have some unread items" do
      @user.unread_items.should_not be nil
    end

  end

end
