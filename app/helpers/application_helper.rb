module ApplicationHelper
  def format_date(date)
    date.strftime('%d.%m %H:%M')
  end
end
