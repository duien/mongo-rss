# hotness_signature_spec.rb

require 'spec_helper'

require File.join( File.dirname(__FILE__), '../lib/hotness_signature.rb' )
require File.join( File.dirname(__FILE__), '../lib/user.rb' )

describe HotnessSignature do

  before do
    @user = User.new
    @sig = HotnessSignature.new
    @user.hotness_signature = @sig
  end

  context "when newly created" do

    it "should be trainable" do
      @sig.train( "This is some text.", 1)
    end

  end

  context "after being trained" do
    
    before do 
      @sig.train( "good awesome wonderful interesting words", 300 )
      @sig.train( "boring crappy skipped sucky words", 3 )
    end

    it "should predict text with good words higher than text with bad words" do
      ( @sig.predict("boring crappy stuff") < @sig.predict("awesome interesting things") ).should be_true
    end

  end

end
