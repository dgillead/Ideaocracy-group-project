module ApplicationHelper
  def flash_class(level)
    case level
      when 'notice' then "alert alert-info fade-out"
      when 'success' then "alert alert-success fade-out"
      when 'error' then "alert alert-danger fade-out"
      when 'alert' then "alert alert-warning fade-out"
    end
  end
end
