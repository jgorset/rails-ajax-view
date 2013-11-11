module AjaxViewHelper
  
  @@ui_element_css_class = "ui_element"
  @@ui_history_element_css_class = "ui_history_element"
  @@ui_container_element_css_class = "ui_container"
  @@ui_body_element_css_class ="ui_body_id"
  
  def ajax_link(*args, &block)
    inject_css(args, @@ui_element_css_class + " " + @@ui_history_element_css_class)
    return link_to(*args, &block)
   
  end
  
  def ajax_button(*args, &block)
    inject_css(args, @@ui_element_css_class)
    result = link_to(*args, &block)
    return ("<button" + result[2..-3] + "button>").html_safe
  end
  
  def ajax_container(*args, &block)
    inject_css(args, @@ui_container_element_css_class)
    return (tag("div",*args, &block)[0..-1] + capture(&block) + "</div>").html_safe 
  end
  
  def ajax_body(&block)
    content_tag "div", id: @@ui_body_element_css_class do
      yield
    end
  end
  
  private 
  def inject_css(args,css_class)
  for arg in args
      if arg.is_a? Hash
        if arg.has_key?(:class)
          arg[:class] += " " + css_class
        else
          arg[:class] = css_class
        end
      end
    end
  end
  
end
