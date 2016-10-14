module MessageHelper
  def convert_views(views)
    return nil if views.nil? || views.to_i <= 0
    views.to_i
  end

  def convert_hours(hours)
    return nil if hours.nil? || hours.to_i <= 0
    Time.current + hours.to_i * 60 * 60
  end

  def update_message(message)
    message.option.delete_after_views -=1
    message.option.save
    message.destroy if message.option.delete_after_views <= 0
    message
  end
end
