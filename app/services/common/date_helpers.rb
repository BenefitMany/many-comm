module Common
  module DateHelpers
    def dateify(date_str_or_obj, default_date = nil)
      retval = convert_to_date(date_str_or_obj.to_s)
      return default_date if retval.nil?

      retval
    end

    def dateify_to_end_of_month(date_str_or_obj, default_date = nil)
      retval = convert_to_date(date_str_or_obj.to_s)
      return default_date if retval.nil?

      retval.end_of_month
    end

    def convert_to_date(date_str)
      if /^[0-9]{4}-[0-9]{2}-[0-9]{2}$/.match?(date_str) # '1980-09-27'
        Date.strptime(date_str.to_s.strip, '%Y-%m-%d')
      elsif %r(^[0-9]{1,2}/[0-9]{1,2}/[0-9]{4}$).match?(date_str)    # '09/27/1980' and '9/27/1980'
        Date.strptime(date_str.to_s.strip, '%m/%d/%Y')
      elsif %r(^[0-9]{1,2}/[0-9]{1,2}/[0-9]{2}$).match?(date_str)    # '09/27/80' and '9/27/80'
        Date.strptime(date_str.to_s.strip, '%m/%d/%y')
      elsif /^[0-9]{8}$/.match?(date_str) # 20180312
        Date.strptime(date_str.to_s.strip, '%Y%m%d')
      elsif !date_str.nil?
        Date.parse(date_str) # anything else that is valid by default
      end
    rescue StandardError
      nil
    end
  end
end
