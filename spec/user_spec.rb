# user_spec.rb

require File.join( File.dirname(__FILE__), '../lib/user.rb' )
require File.join( File.dirname(__FILE__), '../lib/item.rb' )

describe User do

  before do
    @user = User.new
  end

  context "with unread items" do
    before do
      # TODO: once User#items is removed, refactor this
      @user.items = [ Item.new(:body => "Card games are good and interesting and I love them."),
                      Item.new(:body => "Politics are boring and I don't want to read about them."),
                      Item.new(:body => "Books are also interesting and I love them too"),
                      Item.new(:body => "Politics are still boring and they suck."),
                      Item.new(:body => "Books and games are still interesting and I super love them.")
                    ]
    end

    it "should have some unread items" do
      @user.unread_items.should_not be nil
    end

    it "should order the items by hotness" do
      pending "implement bayesian hotness"
    end

  end

end
