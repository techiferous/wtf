require 'date'

module WTF
  class Date
    
    # creates a new WTF::Date object.  The argument can be a string representing the
    # date and/or time in World Time Format, or it can be a Time object.  If the
    # argument is missing, Time.now is assumed.
    #
    # Examples:
    #
    #   WTF::Date.new(":NB")     #=> returns a new WTF::Date object for the WTF time :NB
    #   WTF::Date.new(":RJA")    #=> returns a new WTF::Date object for the WTF date :RJA
    #   WTF::Date.new("MM:BRT")  #=> returns a new WTF::Date object for the WTF datetime MM:BRT
    #   WTF::Date.new            #=> returns a new WTF::Date object corresponding to right now
    #   WTF::Date.new(Time.utc(2010, 5, 6))  #=> returns a new WTF::Date object for the given Time
    #
    # If the argument is in World Time Format, it must can contain a date part,
    # a time part, and a colon to separate them.  Here are some examples of valid formats:
    #
    #   - "FJKRM:BROMQ" -- This is a fully specified World Time Format date and
    #     time.  The first part is the date part and the second part is the time
    #     part.  The date part cannot be longer than five characters.  The time
    #     part can be longer than five characters, but any characters after
    #     the fifth character are ignored when calculating.
    #   - ":BROMQ" -- You can leave out the date part.  Today is assumed.
    #   - "FJKRM:" -- You can leave out the time part.  The beginning of the
    #     Julian day is assumed (which is noon).
    #   - "BROMQ" -- If you leave out the colon, it is assumed that you are
    #     giving the time, not the date.
    #   - "RM:BROMQ" -- You can leave out some of the digits for the date.  If
    #     you do, the remaining digits will be filled in according to today's
    #     date.  If today's date is FMBAZ, then "RM:BROMQ" becomes
    #     "FMBRM:BROMQ".
    #   - ":BR" -- You don't have to specify all five of the time digits.
    #   - "A:B" -- This is a valid format.
    #
    # Also note:
    #
    #   - The date conversion does not work before the Gregorian calendar change
    #     that happened in October 1582.
    #   - Since the date part is limited to five characters, there is an upper
    #     bound for how far into the future you can do a date conversion.
    #   - The time part is limited to five characters and therefore the
    #     time precision is limited to about 10 milliseconds.
    #   - Leap seconds were not taken into account.
    #
    def initialize(time = nil)
      if time
        if time.is_a? String
          @time = convert_from_wtf(time)
        elsif time.is_a? Time
          @time = time
        else
          raise ArgumentError.new("Argument must be a String or a Time.")
        end
      else
        @time = ::Time.now
      end
      @wtf = convert_to_wtf(@time)
    end
    
    # now is a synonym for WTF::Date.new.  It returns a WTF::Date object initialized with
    # the current date and time.
    #
    def self.now
      self.new
    end

    # convert is a convenience method to make it easier to convert between WTF
    # times and standard times.
    #    
    # Examples:
    # 
    #   WTF::Date.convert("FIWIT:NAAAA")  #=> same as WTF::Date.new("FIWIT:NAAAA").as_utc
    #   WTF::Date.convert(time)           #=> same as WTF::Date.new(time).as_wtf
    #
    def self.convert(arg)
      return nil if arg.nil?
      return self.new(arg).as_utc if arg.is_a?(String)
      return self.new(arg).as_wtf if arg.is_a?(Time)
      raise ArgumentError.new("Argument must be a String or a Time.")
    end
    
    # returns a Time object representing the WTF::Date's date and time in UTC.
    #
    # Examples:
    #
    #   standard_time = WTF::Date.new("FIWIT:NAAAA").as_utc
    #   standard_time = WTF::Date.new(":BJR").as_utc
    #   standard_time = WTF::Date.new("XQ:ARM").as_utc
    #
    def as_utc
      @time
    end
    
    # returns a string representing the date and time in World Time Format.
    #
    # Example:
    #
    #   wtf_date = WTF::Date.new(Time.utc(2002, 7, 10, 13, 55, 1, 777000))
    #   wtf_date.as_wtf  #=> "FJNXQ:CCAAA"
    #
    def as_wtf
      @wtf
    end

    # returns just the World Time Format date.
    #
    # Example:
    #
    #   wtf_date = WTF::Date.new(Time.utc(2002, 7, 10, 13, 55, 1, 777000))
    #   wtf_date.date_part  #=> "FJNXQ"
    #
    def date_part
      @wtf =~ /^([A-Z]{0,5}):([A-Z]*)$/
      $1
    end

    # returns just the World Time Format time.
    #
    # Example:
    #
    #   wtf_date = WTF::Date.new(Time.utc(2002, 7, 10, 13, 55, 1, 777000))
    #   wtf_date.time_part  #=> "CCAAA"
    #
    def time_part
      @wtf =~ /^([A-Z]{0,5}):([A-Z]*)$/
      $2
    end

    #--------------------#
    #   PRIVATE METHODS  #
    #++++++++++++++++++++#

    private
    
    MILLIS_IN_A_DAY = 24 * 60 * 60 * 1000  # millis means milliseconds

    def convert_from_wtf(wtf)
      
      if wtf.nil? || wtf.empty?
        raise ArgumentError.new("Argument is empty.")
      end

      # If no colon is given, we assume we have a time, not a date.
      if !wtf.include?(":")
        wtf = ":" + wtf
      end
      if wtf !~ /^([A-Z]{0,5}):([A-Z]*)$/
        raise ArgumentError.new("Time format error")
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
    
    # Given an integer representing the number of milliseconds into the Julian
    # day, return a five-character string representing the time in World Time
    # Format.
    #
    def self.time_to_wtf(millis_into_the_day)
      if (millis_into_the_day < 0)
        raise ArgumentError.new("Negative values are not supported.")
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
