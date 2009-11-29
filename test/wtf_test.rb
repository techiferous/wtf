require 'test/test_helper'
require 'wtf'

class WtfTest < Test::Unit::TestCase

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

  def test_to_wtf
    time = Time.utc(2002, 7, 10, 13, 55, 1, 777000)
    wtf = WTF::Date.new(time)
    assert_equal "FJNXQ", wtf.date_part
    assert_equal "CCAAA", wtf.time_part
    assert_equal "FJNXQ:CCAAA", wtf.as_wtf
  end

  def test_converting_to_wtf
    time = Time.utc(2002, 7, 10, 13, 55, 1, 777000)
    wtf = WTF::Date.new(time)
    assert_equal "FJNXQ", wtf.date_part
    assert_equal "CCAAA", wtf.time_part
    assert_equal "FJNXQ:CCAAA", wtf.as_wtf
  end

  def test_converting_to_standard_time
  end

  def test_now
  end

end
