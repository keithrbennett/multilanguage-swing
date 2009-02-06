require 'test/unit'
require 'FrameInRuby'

class FrameInRubyTester < Test::Unit::TestCase

  def test_float_string_valid

    frame = FrameInRuby.new

    sb_true_values  = ["-1.2345", "0", "1.2345", " -1.2345E4 "]
    sb_false_values = [ "x", "", "+", "_", "x2134", "1_000", "3x"]

    sb_true_values.each  { |val| assert((frame.float_string_valid? val), "#{val} s/b true but was false") }
    sb_false_values.each { |val| assert((! (frame.float_string_valid? val)), "#{val} s/b false but was true") }
  end
end


class TemperatureConversionTester < Test::Unit::TestCase

  include TemperatureConversion

  VALS = [[0, 32], [100, 212]]

  def test_c2f
    VALS.each do |val| 
      c, f = val[0], val[1];
      f_calc = c2f(c)
      assert f == f_calc, "f(#{c}) s/b #{f} but was #{f_calc}."
    end
  end
end
