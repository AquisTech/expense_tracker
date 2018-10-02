class Time
  # wday_number : 0 = Sunday, 1 = Monday, 2 = Tuesday, ...
  def date_of_next_wday(wday_number)
    self + ((wday_number - self.wday) % 7).days
  end

  def date_of_last_wday(wday_number)
    self - ((self.wday - wday_number) % 7).days
  end

  def date_of_nth_day(day_number)
    self.change(day: day_number)
  end

  def date_of_next_nth_day(day_number)
    return self.end_of_month if day_number == -1 # TODO: Check if this can be moved to date_of_nth_day
    nth_day = self.date_of_nth_day(day_number)
    # 9     <     10      next 9
    # 10    <     10      current
    # 11    <     10      current
    nth_day < self ? nth_day.next_month : nth_day
  end

  def date_of_last_nth_day(day_number)
    return self.last_month.end_of_month if day_number == -1 # TODO: Check if this can be moved to date_of_nth_day
    nth_day = self.date_of_nth_day(day_number)
    # 9      >     10        current
    # 10     >     10        current
    # 11     >     10        last 11
    nth_day > self ? nth_day.last_month : nth_day
  end

  def date_of_nth_wday(week_number, wday_number)
    self.beginning_of_month.date_of_next_wday(wday_number) + (week_number - 1).weeks
  end

  def date_of_next_nth_wday(week_number, wday_number)
    nth_wday = self.date_of_nth_wday(week_number, wday_number)
    nth_wday < self ? nth_wday.next_month : nth_wday
  end

  def date_of_last_nth_wday(week_number, wday_number)
    nth_wday = self.date_of_nth_wday(week_number, wday_number)
    nth_wday > self ? nth_wday.last_month : nth_wday
  end

  def date_of_nth_month_day(month_number, day_number)
    return self.change(month: month_number).end_of_month if day_number == -1
    self.change(month: month_number, day: day_number)
  end

  def date_of_next_nth_month_day(month_number, day_number)
    nth_month_day = self.date_of_nth_month_day(month_number, day_number)
    nth_month_day < self ? nth_month_day.next_year : nth_month_day # TODO: Check for last day of FEB
  end

  def date_of_last_nth_month_day(month_number, day_number)
    nth_month_day = self.date_of_nth_month_day(month_number, day_number)
    nth_month_day > self ? nth_month_day.last_year : nth_month_day # TODO: Check for last day of FEB
  end

  def date_of_nth_month_wday(month_number, week_number, wday_number)
    Time.new(self.year, month_number).date_of_next_wday(wday_number) + (week_number - 1).weeks
  end

  def date_of_next_nth_month_wday(month_number, week_number, wday_number)
    nth_month_wday = self.date_of_nth_month_wday(month_number, week_number, wday_number)
    nth_month_wday < self ? nth_month_wday.next_year : nth_month_wday
  end

  def date_of_last_nth_month_wday(month_number, week_number, wday_number)
    nth_month_wday = self.date_of_nth_month_wday(month_number, week_number, wday_number)
    nth_month_wday > self ? nth_month_wday.last_year : nth_month_wday
  end
end
