# frozen_string_literal: true

module BigPicture
  class HookListener < Redmine::Hook::ViewListener
    def view_layouts_base_html_head(context)
      javascript_include_tag('../big_picture/javascripts/BigPicture.min.js', plugin: 'redmica_ui_extension') +
      javascript_include_tag('../big_picture/javascripts/preview_attachment.js', plugin: 'redmica_ui_extension')
    end
  end
end
