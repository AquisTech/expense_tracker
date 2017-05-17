module RecurrenceRulesHelper
  def weekday_select_bar
    content_tag :div, class: 'input-group' do
      Date::ABBR_DAYNAMES.map.with_index do |day, i|
        label_tag i, day, class: 'input-group-label'
      end.join.html_safe
    end
  end

  def day_of_month_selection
    ((1..31).to_a << -1).in_groups_of(7).map do |days_of_week|
      content_tag :div, class: 'row columns' do
        days_of_week.compact.map do |day|
          if day == -1
            content_tag :div, 'Last day of month', for: day, class: 'small-4 columns end'
          else
            content_tag :div, day, for: day, class: "small-1 columns #{'end' if (day % 7).zero?}"
          end
        end.join.html_safe
      end
    end.join.html_safe
  end

  def day_of_week_selection
    [1, 2, 3, 4, -1].map do |week_number|
      content_tag :div, class: 'row columns' do
        content_tag(:div, (week_number == -1 ? 'Last' : week_number.ordinalize), class: "small-1 columns") +
        Date::ABBR_DAYNAMES.map do |day|
          content_tag(:div, day, class: "small-1 columns #{'end' if Date::ABBR_DAYNAMES.index(day) == 6}")
        end.join.html_safe
      end
    end.join.html_safe
  end
end
