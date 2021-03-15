# used for displaying the date throughout the application. Since some database fields are
# both of type Date and DateTime add  the format to both.
Time::DATE_FORMATS[:basic_date] = "%m/%d/%Y"
Date::DATE_FORMATS[:basic_date] = "%m/%d/%Y"
Time::DATE_FORMATS[:basic_short_date] = "%m/%d/%y"
Date::DATE_FORMATS[:basic_short_date] = "%m/%d/%y"

Time::DATE_FORMATS[:basic_time] = "%I:%M%p"
Date::DATE_FORMATS[:basic_time] = "%I:%M%p"

Time::DATE_FORMATS[:basic_time_without_leading_zero] = "%l:%M %p"
Date::DATE_FORMATS[:basic_time_without_leading_zero] = "%l:%M %p"

Time::DATE_FORMATS[:full_stamp] = "%a %B %d at %I:%M %p"
Time::DATE_FORMATS[:short_stamp] = '%D %I:%M %p' # shorter than :full_stamp to conserve column space (and no seconds)

Time::DATE_FORMATS[:basic_datestamp] = "%m/%d/%Y %I:%M%p"
Date::DATE_FORMATS[:basic_datestamp] = "%m/%d/%Y %I:%M%p"
