require File.dirname(__FILE__) + '/test_helper.rb'
require 'kagemusha'
require 'open-uri'

class Test_Thumbnail < Test::Unit::TestCase
  def setup
    @client = Nicovideo::Thumbnail.new
  end

  def test_get
    thumbnail = @client.get("sm9")
    assert("sm9", thumbnail["video_id"])
    assert("新・豪血寺一族 -煩悩解放 - レッツゴー！陰陽師", thumbnail["title"])
    assert thumbnail["size_high"] > 0
  end

  def test_get_nonexistent_video
    assert_raise(::Errno::ENOENT) {
      @client.get "sm1"
    }
  end

  def test_get_timeout
     Kagemusha.new(Kernel) do |m|
       m.def(:open) { sleep 30 }
       m.swap {
         assert_raise(TimeoutError) {
           @client.get("sm2424611", 0.1, 0)
         }
       }
     end
   end
end
