module ApplicationHelper
  def errors_for(model)
    unless model.errors.empty?
      content_tag :div, model.errors.full_messages.join(', ')
    end
  end

  def not_html_safe
    '<div class="not-html-safe">This is the string your mom warned you about</div>'.html_safe
  end
end
