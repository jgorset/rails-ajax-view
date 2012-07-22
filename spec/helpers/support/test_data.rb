module TestData
  CONTENT = "content"
  AJAX_BODY = '<div id="ui_body_id" />%s</div>' % CONTENT
  CONTAINER_PARAMS = { :id=>"button1_container", :class => "css_class" }
  CONTAINER_BODY = '<div class="css_class ui_container" id="button1_container" />content</div>'
  LINK_BODY = '<a href="/tab1" class="css_class ui_element ui_history_element" id="tab1_id" target="tab1_container">tab1</a>'
  BUTTON_BODY = '<button href="/button1" class="css_class ui_element" id="button_1_id" target="button2_container">button1</button>'
end