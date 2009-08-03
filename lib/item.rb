# A totally stubby Item class.  Should probably be wiped and re-done from
# scratch once we figure out how these are going to work.  If you change the
# name of the :body method, make sure to do a search/replace in the specs and
# other classes, as well.

class Item

  attr_accessor , :body

  def initialize (body)
    @body = body
  end

end
