require 'test/test_helper'
require 'wtf'

class WtfTest < Test::Unit::TestCase

  def test_basic
    time = Time.utc(2002, 7, 10, 13, 55, 1, 777000)
    wtf = WTF::Date.new(time)
    assert_equal "FJNXQ", wtf.date_part
    assert_equal "CCAAA", wtf.time_part
    assert_equal "FJNXQ:CCAAA", wtf.as_wtf
  end

  # def test_simple_rgb_to_hex_errors
  #   assert_raise ArgumentError do
  #     ReggieB.to_hex(255, 256, 255)
  #   end
  #   assert_raise ArgumentError do
  #     ReggieB.to_hex(-10, 10, 10)
  #   end
  #   assert_raise ArgumentError do
  #     ReggieB.to_hex(8, 9, 1000)
  #   end
  # end

end
