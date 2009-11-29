require 'test/test_helper'
require 'wtf'

class WtfTest < Test::Unit::TestCase

  #--------------------------#
  # Testing private methods. #
  #--------------------------#
  
  def test_alphabase_conversion_with_whole_numbers
    assert_equal "A", WTF::Date.send(:decimal_to_alphabase, 0)
    assert_equal "B", WTF::Date.send(:decimal_to_alphabase, 1)
    assert_equal "C", WTF::Date.send(:decimal_to_alphabase, 2)
    assert_equal "J", WTF::Date.send(:decimal_to_alphabase, 9)
    assert_equal "Z", WTF::Date.send(:decimal_to_alphabase, 25)
    assert_equal "BA", WTF::Date.send(:decimal_to_alphabase, 26)
    assert_equal "BB", WTF::Date.send(:decimal_to_alphabase, 27)
    assert_equal "BAA", WTF::Date.send(:decimal_to_alphabase, 676)
    assert_equal "BAB", WTF::Date.send(:decimal_to_alphabase, 677)
    assert_equal "BAC", WTF::Date.send(:decimal_to_alphabase, 678)
  end

  def test_alphabase_conversion_with_negative_numbers
    assert_equal "-B", WTF::Date.send(:decimal_to_alphabase, -1)
    assert_equal "-C", WTF::Date.send(:decimal_to_alphabase, -2)
    assert_equal "-BB", WTF::Date.send(:decimal_to_alphabase, -27)
    assert_equal "-BAA", WTF::Date.send(:decimal_to_alphabase, -676)
  end

  def test_alphabase_conversion_with_floats
    assert_raise ArgumentError do
      WTF::Date.send(:decimal_to_alphabase, 7.7)
    end
  end

  def test_time_to_wtf
    assert_equal "AAAAA", WTF::Date.send(:time_to_wtf, 0) # midnight
    assert_equal "NAAAA", WTF::Date.send(:time_to_wtf, 12*60*60*1000) # noon
    assert_equal "BAAAA", WTF::Date.send(:time_to_wtf, 3323077)
  end

  #---------------------#
  # Testing public API. #
  #---------------------#

  def test_converting_to_wtf

    time = Time.utc(1970, 1, 1, 0)
    wtf = WTF::Date.new(time)
    assert_equal "FIWIT", wtf.date_part
    assert_equal "NAAAA", wtf.time_part
    assert_equal "FIWIT:NAAAA", wtf.as_wtf

    time = Time.utc(1969, 12, 31, 12)
    wtf = WTF::Date.new(time)
    assert_equal "FIWIT", wtf.date_part
    assert_equal "AAAAA", wtf.time_part
    assert_equal "FIWIT:AAAAA", wtf.as_wtf

    time = Time.utc(2002, 7, 10, 12)
    wtf = WTF::Date.new(time)
    assert_equal "FJNXQ", wtf.date_part
    assert_equal "AAAAA", wtf.time_part
    assert_equal "FJNXQ:AAAAA", wtf.as_wtf

    time = Time.utc(2002, 7, 10, 13, 55, 1, 777000)
    wtf = WTF::Date.new(time)
    assert_equal "FJNXQ", wtf.date_part
    assert_equal "CCAAA", wtf.time_part
    assert_equal "FJNXQ:CCAAA", wtf.as_wtf

  end

  def test_converting_to_standard_time
    time = Time.utc(1970, 1, 1, 0)
    assert_equal time, WTF::Date.new("FIWIT:NAAAA").as_utc
    assert_equal time, WTF::Date.new("FIWIT:NAAA").as_utc
    assert_equal time, WTF::Date.new("FIWIT:NAA").as_utc
    assert_equal time, WTF::Date.new("FIWIT:NA").as_utc
    assert_equal time, WTF::Date.new("FIWIT:N").as_utc
    time = Time.utc(1969, 12, 31, 12)
    assert_equal time, WTF::Date.new("FIWIT:AAAAA").as_utc
    assert_equal time, WTF::Date.new("FIWIT:AAAA").as_utc
    assert_equal time, WTF::Date.new("FIWIT:AAA").as_utc
    assert_equal time, WTF::Date.new("FIWIT:AA").as_utc
    assert_equal time, WTF::Date.new("FIWIT:A").as_utc
    assert_equal time, WTF::Date.new("FIWIT:").as_utc
    assert_equal time, WTF::Date.new("IWIT:").as_utc
    assert_equal time, WTF::Date.new("IWIT:A").as_utc
    assert_equal time, WTF::Date.new("IWIT:AA").as_utc
    time = Time.utc(2002, 7, 10, 12)
    assert_equal time, WTF::Date.new("FJNXQ:AAAAA").as_utc
    assert_equal time, WTF::Date.new("FJNXQ:").as_utc
    assert_equal time, WTF::Date.new("NXQ:").as_utc
    time = Time.utc(2002, 7, 10, 13, 55, 1, 777000)
    assert_in_delta time.to_f, WTF::Date.new("FJNXQ:CCAAA").as_utc.to_f, 0.006
    assert_in_delta time.to_f, WTF::Date.new("FJNXQ:CC").as_utc.to_f, 0.006
    assert_equal 12, WTF::Date.new(":AA").as_utc.hour
    assert_equal 0, WTF::Date.new(":AA").as_utc.min
    assert_equal 0, WTF::Date.new(":N").as_utc.hour
    assert_equal 0, WTF::Date.new(":N").as_utc.min
    assert_equal 0, WTF::Date.new("N").as_utc.hour
    assert_equal 0, WTF::Date.new("N").as_utc.min
    assert_equal 12, WTF::Date.new(":").as_utc.hour
    assert_equal 0, WTF::Date.new(":").as_utc.min
    assert_raise ArgumentError do
      WTF::Date.new("").as_utc
    end
    assert_raise ArgumentError do
      WTF::Date.new("ABCDEF:ABC").as_utc # date part can't be longer than five characters
    end
    assert_nothing_raised do
      WTF::Date.new("FJCDE:ABCDEFGHIJ").as_utc # time part can be longer than five characters
    end
  end

  def test_now
    wtf = WTF::Date.now
    wtf2 = WTF::Date.now
    time = wtf.as_utc
    time2 = wtf2.as_utc
    past = Time.utc(2009, 11, 28)
    future = Time.utc(2030, 1, 12)
    assert time <= time2
    assert time < future
    assert time > past
  end
  
  def test_convert
    time = Time.utc(1970, 1, 1, 0)
    assert_equal time, WTF::Date.convert("FIWIT:NAAAA")
    assert_equal time, WTF::Date.convert("FIWIT:NAA")
    assert_equal time, WTF::Date.convert("FIWIT:N")
    assert_equal time, WTF::Date.convert("IWIT:N")
    assert_equal "FIWIT:NAAAA", WTF::Date.convert(time)
  end

end
