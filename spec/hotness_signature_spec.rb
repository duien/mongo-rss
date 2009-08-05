# hotness_signature_spec.rb

require File.join( File.dirname(__FILE__), '../lib/hotness_signature.rb' )

describe HotnessSignature do

  context "when newly created" do

    before do
      @sig = HotnessSignature.new
    end

  end

end
