require 'date'
module WTF
  class Date
    
    def initialize(time = nil)
      if time
        if time.is_a? String
          @time = convert_from_wtf(time)
        elsif time.is_a? Time
          @time = time
        else
          raise "Bad argument" # fill in......
        end
      else
        @time = Time.now
      end
      @wtf = convert_to_wtf(@time)
    end
    
    def self.now
      self.new
    end
    
    def as_utc
      @time
    end
    
    def as_wtf
      @wtf
    end

    def date_part
      @wtf =~ /^([A-Z]{0,5}):([A-Z]*)$/
      $1
    end

    def time_part
      @wtf =~ /^([A-Z]{0,5}):([A-Z]*)$/
      $2
    end

    private
    
    MILLIS_IN_A_DAY = 24 * 60 * 60 * 1000  # millis means milliseconds

    def convert_from_wtf(wtf)

      # If no colon is given, we assume we have a time, not a date.
      if !wtf.include?(":")
        wtf = ":" + wtf
      end
      if wtf !~ /^([A-Z]{0,5}):([A-Z]*)$/
        raise "Time format error" # fill in........
      end
      wtf_date = $1
      wtf_time = $2
      
      if wtf_date.length < 5
        reference_date = self.class.now.date_part
        wtf_date = reference_date[0, 5-wtf_date.length] + wtf_date
      end
      
      if wtf_time.length > 5
        wtf_time = wtf_time[0, 5]
      end

      julian_date = 0
      # compute integer part of Julian Date
      for i in (0..4) do
        julian_date += (wtf_date[i]-65) * (26**(4-i))
      end
      # compute fractional part of Julian Date
      fractional = 0
      for i in (0..(wtf_time.length-1)) do
        fractional += (wtf_time[i]-65) / (26**(i+1)).to_f
      end
      
      if fractional >= 0.5
        fractional -= 0.5
        julian_date += 1
      else
        fractional += 0.5
      end

      offset = ::DateTime.now.offset
      date = ::Date.jd(julian_date+fractional)
      
      # Normally I love Ruby and how it gets out of my way, but this is
      # absolutely ridiculous.  I expect to be able to create a Date object,
      # initialize it with the Julian Day, then simply call to_time.
      # Why Ruby doesn't provide a to_time method, I don't know.  So I'm resorting
      # to calling private (!) methods on the Date class.  Shame on Ruby
      # and shame on me! :)
      fraction_of_seconds = date.send(:sec_fraction) * 86400 # seconds in a day
      microseconds = fraction_of_seconds * 1000000
      utc_time = ::Time.utc(date.year,
                           date.month,
                           date.day,
                           date.send(:hour),
                           date.send(:min),
                           date.send(:sec),
                           microseconds)

      utc_time.getlocal

    end
    
    def convert_to_wtf(time)      
      utc = time.utc
      
      date = ::Date.civil(utc.year, utc.month, utc.day)
      julian_day = date.jd.to_i
      seconds_in_a_day = 86400;
      # adjust for astronomical julian day
      if utc.hour >= 12
        hour = utc.hour - 12
      else
        hour = utc.hour + 12
        julian_day -= 1
      end
      fractional = hour * 3600 + utc.min * 60 + utc.sec + (utc.usec / 1000000.0)
      date_part = self.class.decimal_to_alphabase(julian_day)
      time_part = self.class.time_to_wtf(fractional*1000)
      
      date_part + ':' + time_part
    end
    
    # Given a number in base 10, return a number in alphabase.  Note that
    # alphabase is different than base 26.  Base 26 uses digits within the range
    # 0-9,a-p.  Alphabase is also based on a radix of 26, but uses digits within
    # the range A-Z.
    # 
    # To simplify the algorithm, this function does not accept real numbers as
    # input, only integers.
    # 
    def self.decimal_to_alphabase(decimal)
      if (decimal.floor != decimal)
        raise ArgumentError.new("Floats are not supported.")
      end
      alphabase = ""
      base26 = decimal.to_s(26)
      for i in (0..(base26.length-1))
        c = base26[i]
        if (c == 45) # hyphen for negative numbers
          alphabase += "-"
        elsif ((c >= 97) && (c <= 112)) # lower case a-p -> K-Z
          alphabase += (c-22).chr
        elsif ((c >= 48) && (c <= 57)) # number 0-9 -> A-J
          alphabase += (c+17).chr
        else
          raise "Unexpected character."
        end
      end
      alphabase
    end
    
    def self.time_to_wtf(millis_into_the_day)
      if (millis_into_the_day < 0)
        raise "Negative values are not supported." # fil in ...........
      end
      if (millis_into_the_day >= MILLIS_IN_A_DAY)
        raise "Value (#{millis_into_the_day}) must be smaller than the number of milliseconds in a day (#{MILLIS_IN_A_DAY})." # fil in ...
      end
      result = ""
      # For the first loop iteration, the unit represents the number of
      # milliseconds in an entire day.  Then it represents the number of
      # milliseconds in an alphabetic hour, then in an alphabetic minute, all
      # the way down to the number of milliseconds in an alphabetic subsubsecond.
      unit = MILLIS_IN_A_DAY
      remainder = millis_into_the_day  # milliseconds left to process
      5.times do
        unit /= 26.0
        num_units = (remainder.floor / unit).to_i
        remainder -= (num_units * unit)
        result += (num_units.to_i+65).chr
      end
      result
    end
    
  end
end
