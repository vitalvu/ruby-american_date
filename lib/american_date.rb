require 'date'

if RUBY_VERSION >= '1.9'
  # Modify parsing methods to handle american date format correctly.
  class << Date
    # American date format detected by the library.
    AMERICAN_DATE_SHORT = %r_\A\s*(\d{1,2})/(\d{1,2})/(\d{2})_.freeze
    AMERICAN_DATE_LONG = %r_\A\s*(\d{1,2})/(\d{1,2})/(\d{4})_.freeze


    # Alias for stdlib Date._parse
    alias _parse_without_american_date _parse

    # Transform american dates into ISO dates before parsing.
    def _parse(string, comp=true)
      _parse_without_american_date(convert_american_to_iso(string), comp)
    end

    if RUBY_VERSION >= '1.9.3'
      # Alias for stdlib Date.parse
      alias parse_without_american_date parse

      # Transform american dates into ISO dates before parsing.
      def parse(string, comp=true)
        parse_without_american_date(convert_american_to_iso(string), comp)
      end
    end

    private

    # Transform american date fromat into ISO format.
    def convert_american_to_iso(string)
      if (string =~ AMERICAN_DATE_LONG) ==0
        string.sub(AMERICAN_DATE_LONG){|m| "#$3-#$1-#$2"}
      elsif (string =~ AMERICAN_DATE_SHORT) ==0
        string.sub(AMERICAN_DATE_SHORT){|m| "20#$3-#$1-#$2"}
      else
        string
      end
    end
  end

  if RUBY_VERSION >= '1.9.3'
    # Modify parsing methods to handle american date format correctly.
    class << DateTime
      # Alias for stdlib Date.parse
      alias parse_without_american_date parse

      # Transform american dates into ISO dates before parsing.
      def parse(string, comp=true)
        parse_without_american_date(convert_american_to_iso(string), comp)
      end
    end
  end
end
