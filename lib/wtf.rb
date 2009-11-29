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
    
    def as_standard_time
      @time
    end
    
    def as_wtf
      @wtf
    end

    def date_part
      @wtf.split(':').first
    end

    def time_part
      @wtf.split(':').last
    end

    private
    
    MILLIS_IN_A_DAY = 24 * 60 * 60 * 1000  # millis means milliseconds

    def convert_from_wtf(wtf)

      # If no colon is given, we assume we have a time, not a date.
      if !wtf.include?(":")
        wtf = ":" + wtf
      end
      if wtf !~ /^[A-Z]{0,5}:[A-Z]*$/
        raise "Time format error" # fill in........
      end
      wtf_date = wtf.split(':').first
      wtf_time = wtf.split(':').last
      
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

      offset = ::DateTime.now.offset
      date = ::Date.jd(julian_date+fractional)
      
      # Normally I love Ruby and how it gets out of my way, but this is
      # absolutely ridiculous.  I expect to be able to create a Date object,
      # initialize it with the Julian Day, then simply call to_time.
      # Why Ruby doesn't provide a to_time method, I don't know.  So I'm resorting
      # to calling private (!) methods on the Date class.  Shame on Ruby
      # and shame on me! :)
      utc_time = ::Time.utc(date.year,
                           date.month,
                           date.day,
                           date.send(:hour),
                           date.send(:min),
                           date.send(:sec)+date.send(:sec_fraction))

      utc_time.getlocal

    end
    
    def convert_to_wtf(time)      
      utc = time.utc
      
      date = ::Date.civil(utc.year, utc.month, utc.day)
      julian_day = date.ajd.to_i
      seconds_in_a_day = 86400;
      # adjust for astronomical julian day
      if utc.hour >= 12
        hour = utc.hour - 12
      else
        hour = utc.hour + 12
      end
      fractional = hour * 3600 + utc.min * 60 + utc.sec + (utc.usec / 1000000.0)
      date_part = decimal_to_alphabase(julian_day)
      time_part = time_to_wtf(fractional*1000)
      
      date_part + ':' + time_part
    end
    
    def decimal_to_alphabase(julian_day)
      if (julian_day.floor != julian_day)
        raise "Real numbers not supported." # fil in...
      end
      alphabase = ""
      base26 = julian_day.to_s(26)
      for i in (0..(base26.length-1)) do
        c = base26[i]
        if (c == 45) # hyphen for negative numbers
          alphabase += "-"
        elsif ((c >= 97) && (c <= 112)) # lower case a-p -> K-Z
          alphabase += (c-22).chr
        elsif ((c >= 48) && (c <= 57)) # number 0-9 -> A-J
          alphabase += (c+17).chr
        else
          raise "Unexpected character." # fil in ............
        end
      end
      alphabase
    end
    
    def time_to_wtf(millis_into_the_day)
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
        unit = unit.to_f / 26
        num_units = (remainder.floor / unit.to_f).to_i
        remainder = remainder - (num_units * unit)
        result += (num_units.to_i+65).chr
      end
      result
    end
    
  end
end
