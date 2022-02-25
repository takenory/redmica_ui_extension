# frozen_string_literal: true

require_dependency 'application_helper'

module BigPicture
  module ApplicationHelperPatch
    def self.included(base)
      base.send(:prepend, InstanceMethods)
    end

    module InstanceMethods
      def link_to_attachment(attachment, options={})
        use_big_picture = Setting.enabled_redmica_ui_extension_feature?('big_picture') &&
                          options[:download] &&
                          (attachment.is_image? || attachment.is_pdf? || attachment.is_video? || attachment.is_audio?)
        attachment_link = super(attachment, options)
        if use_big_picture
          filename = attachment.filename
          bp_src = if attachment.is_image?
                     'imgSrc'
                   elsif attachment.is_video?
                     'vidSrc'
                   elsif attachment.is_audio?
                     'audio'
                   else # attachment.is_pdf?
                     'iframeSrc'
                   end
          url = download_named_attachment_url(attachment, { filename: filename })
          link_to('',
                  '#',
                  :class => 'icon-only icon-zoom-in',
                  :data => { :bp => filename, :caption => filename, :bp_src => bp_src, :url => url },
                  :onclick => 'openBigPicture(this)').html_safe + attachment_link
        else
          attachment_link
        end
      end
    end
  end
end
