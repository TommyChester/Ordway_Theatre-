require "test_helper"

class ShowingTest < ActiveSupport::TestCase
   test "is_movie?" do
     x = Showing.new
     x.type_of_show = 'movie'
     assert x.is_movie?
     x.type_of_show = 'celtic dance'
     assert_not x.is_movie?
   end
end
