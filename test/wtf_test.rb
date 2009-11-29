require 'test/test_helper'
require 'wtf'

class WtfTest < Test::Unit::TestCase

  def test_basic
    time = Time.utc(2002, 7, 10, 13, 55, 1.777)
    wtf = WTF::Date.new(time)
    assert_equal "FJNXQ", wtf.date_part
    assert_equal "CCAAA", wtf.time_part
    assert_equal "FJNXQ:CCAAA", wtf.as_wtf
  end

  # def test_simple_rgb_to_hex
  #   assert_equal "0xffffff", ReggieB.to_hex(255, 255, 255)
  #   assert_equal "0x000000", ReggieB.to_hex(0, 0, 0)
  #   assert_equal "0x00000f", ReggieB.to_hex(0, 0, 15)
  #   assert_equal "0x001100", ReggieB.to_hex(0, 17, 0)
  #   assert_equal "0xa01100", ReggieB.to_hex(160, 17, 0)
  # end
  # 
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
  # 
  # def test_simple_hex_to_rgb
  #   assert_equal  [255, 255, 255],  ReggieB.to_rgb("0xffffff")
  #   assert_equal  [0, 0, 0],        ReggieB.to_rgb("0x000000")
  #   assert_equal  [0, 0, 15],       ReggieB.to_rgb("0x00000f")
  #   assert_equal  [0, 17, 0],       ReggieB.to_rgb("0x001100")
  #   assert_equal  [160, 17, 0],     ReggieB.to_rgb("0xa01100")
  #   assert_equal  [0, 17, 0],       ReggieB.to_rgb("001100")
  #   assert_equal  [160, 17, 0],     ReggieB.to_rgb("a01100")
  #   assert_equal  [160, 17, 0],     ReggieB.to_rgb("A01100")
  #   assert_equal  [255, 255, 255],  ReggieB.to_rgb("0xFFFFFF")
  # end
  # 
  # def test_simple_hex_to_rgb_errors
  #   assert_raise ArgumentError do
  #     ReggieB.to_rgb("0xfff")
  #   end
  #   assert_raise ArgumentError do
  #     ReggieB.to_rgb("fff")
  #   end
  #   assert_raise ArgumentError do
  #     ReggieB.to_rgb("forks")
  #   end
  #   assert_raise ArgumentError do
  #     ReggieB.to_rgb("0x7897zq")
  #   end
  # end
  # 
  # def test_six_digit_hex
  #   assert_equal  [255, 255, 255],  ReggieB.convert("0xffffff")
  #   assert_equal  [0, 0, 0],        ReggieB.convert("0x000000")
  #   assert_equal  [0, 0, 15],       ReggieB.convert("0x00000f")
  #   assert_equal  [0, 17, 0],       ReggieB.convert("0x001100")
  #   assert_equal  [160, 17, 0],     ReggieB.convert("0xa01100")
  #   assert_equal  [0, 17, 0],       ReggieB.convert("001100")
  #   assert_equal  [160, 17, 0],     ReggieB.convert("a01100")
  #   assert_equal  [160, 17, 0],     ReggieB.convert("A01100")
  #   assert_equal  [255, 255, 255],  ReggieB.convert("0xFFFFFF")
  # end
  # 
  # def test_three_digit_hex
  #   assert_equal  [255, 255, 255],  ReggieB.convert("0xfff")
  #   assert_equal  [0, 0, 0],        ReggieB.convert("0x000")
  #   assert_equal  [0, 0, 255],      ReggieB.convert("0x00f")
  #   assert_equal  [0, 17, 0],       ReggieB.convert("0x010")
  #   assert_equal  [34, 0, 170],     ReggieB.convert("0x20a")
  #   assert_equal  [255, 255, 255],  ReggieB.convert("0xFFF")
  #   assert_equal  [0, 0, 255],      ReggieB.convert("0x00F")
  #   assert_equal  [34, 0, 170],     ReggieB.convert("0x20A")
  #   assert_equal  [255, 255, 255],  ReggieB.convert("FFF")
  #   assert_equal  [0, 0, 255],      ReggieB.convert("00F")
  #   assert_equal  [34, 0, 170],     ReggieB.convert("20A")
  #   assert_equal  [255, 255, 255],  ReggieB.convert("fff")
  # end
  # 
  # def test_wrong_digit_hex
  #   assert_raise ArgumentError do
  #     ReggieB.convert("0xffff")
  #   end
  #   assert_raise ArgumentError do
  #     ReggieB.convert("0x12345")
  #   end
  #   assert_raise ArgumentError do
  #     ReggieB.convert("0x123456789")
  #   end
  #   assert_raise ArgumentError do
  #     ReggieB.convert("0x1")
  #   end
  #   assert_raise ArgumentError do
  #     ReggieB.convert("0x")
  #   end
  # end
  # 
  # def test_hex_prefixes
  #   assert_equal  [255, 255, 255],  ReggieB.convert("0xffffff")
  #   assert_equal  [0, 170, 0],      ReggieB.convert("0x0a0")
  #   assert_equal  [0, 0, 11],       ReggieB.convert("0x00000B")
  #   assert_equal  [255, 255, 255],  ReggieB.convert("ffffff")
  #   assert_equal  [0, 170, 0],      ReggieB.convert("0a0")
  #   assert_equal  [0, 0, 11],       ReggieB.convert("00000B")
  #   assert_equal  [255, 255, 255],  ReggieB.convert("#ffffff")
  #   assert_equal  [0, 170, 0],      ReggieB.convert("#0a0")
  #   assert_equal  [0, 0, 11],       ReggieB.convert("#00000B")
  # end
  # 
  # def test_whitespace
  #   assert_equal  [255, 255, 255],  ReggieB.convert(" 0xffffff ")
  #   assert_equal  [0, 170, 0],      ReggieB.convert("    0x0a0    ")
  #   assert_equal  [0, 0, 11],       ReggieB.convert("0x00000B  ")
  #   assert_equal  [255, 255, 255],  ReggieB.convert(" ffffff")
  #   assert_equal  [0, 170, 0],      ReggieB.convert("\t0a0")
  #   assert_equal  [0, 0, 11],       ReggieB.convert("\n00000B\t")
  #   assert_equal  [255, 255, 255],  ReggieB.convert("               #ffffff")
  #   assert_equal  [0, 170, 0],      ReggieB.convert("#0a0\n")
  #   assert_equal  [0, 0, 11],       ReggieB.convert(" #00000B ")
  # end
  # 
  # def test_bad_hex_digits
  #   assert_raise ArgumentError do
  #     ReggieB.convert("0xbcq")
  #   end
  #   assert_raise ArgumentError do
  #     ReggieB.convert("ffg")
  #   end
  #   assert_raise ArgumentError do
  #     ReggieB.convert("0x0967uf")
  #   end
  # end
  # 
  # def test_semicolons
  #   assert_equal  [255, 255, 255],  ReggieB.convert("0xffffff;")
  #   assert_equal  [0, 170, 0],      ReggieB.convert("    0x0a0;")
  #   assert_equal  [0, 0, 11],       ReggieB.convert("0x00000B;  ")
  #   assert_equal  [255, 255, 255],  ReggieB.convert(" ffffff;")
  #   assert_equal  [0, 170, 0],      ReggieB.convert("\t0a0    ;")
  #   assert_equal  [0, 0, 11],       ReggieB.convert("\n00000B\t;")
  #   assert_equal  [255, 255, 255],  ReggieB.convert("               #ffffff;")
  #   assert_equal  [0, 170, 0],      ReggieB.convert("#0a0;")
  #   assert_equal  [0, 0, 11],       ReggieB.convert("#00000B;")
  # end
  # 
  # def test_simple_rgb
  #   assert_equal "0xffffff", ReggieB.convert("255, 255, 255")
  #   assert_equal "0x000000", ReggieB.convert("0, 0, 0")
  #   assert_equal "0x00000f", ReggieB.convert("0, 0, 15")
  #   assert_equal "0x001100", ReggieB.convert("0, 17, 0")
  #   assert_equal "0xa01100", ReggieB.convert("160, 17, 0")
  # end
  # 
  # def test_rgb_whitespace
  #   assert_equal "0xffffff", ReggieB.convert("255,255,255")
  #   assert_equal "0x000000", ReggieB.convert("       0, 0, 0        ")
  #   assert_equal "0x00000f", ReggieB.convert("0\t0\t15")
  #   assert_equal "0x001100", ReggieB.convert("\t0        17,0")
  #   assert_equal "0xa01100", ReggieB.convert("  160, 17, 0  ")
  # end
  # 
  # def test_rgb_semicolons
  #   assert_equal "0xffffff", ReggieB.convert("255,255,255;")
  #   assert_equal "0x000000", ReggieB.convert("       0, 0, 0;        ")
  #   assert_equal "0x00000f", ReggieB.convert("0\t0\t15;")
  #   assert_equal "0x001100", ReggieB.convert("\t0        17,0;")
  #   assert_equal "0xa01100", ReggieB.convert("  160, 17, 0  ;")
  # end
  # 
  # def test_rgb_delimeters
  #   assert_equal "0xffffff", ReggieB.convert("255-255-255")
  #   assert_equal "0x000000", ReggieB.convert("0 0 0")
  #   assert_equal "0x00000f", ReggieB.convert("0   0   15")
  #   assert_equal "0x001100", ReggieB.convert("rgb(0, 17, 0)")
  #   assert_equal "0xa01100", ReggieB.convert("rgb(160, 17, 0);")
  # end
  # 
  # def test_rgb_percentages
  #   assert_equal "0xffffff", ReggieB.convert("rgb(100%, 100%, 100%)")
  #   assert_equal "0xff7f7f", ReggieB.convert("rgb(100%, 50%, 50%)")
  #   assert_equal "0x000000", ReggieB.convert("rgb(0%, 0%, 0%)")
  #   assert_equal "0xffffff", ReggieB.convert("rgb(100%, 100%, 100%);")
  #   assert_equal "0x7fff7f", ReggieB.convert("50% 100% 50%")
  #   assert_equal "0x7fff7f", ReggieB.convert("    50%      100%     50%   ")
  #   assert_equal "0x7fff7f", ReggieB.convert("50%100%50%")
  # end

end
