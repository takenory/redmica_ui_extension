# frozen_string_literal: true

require_dependency 'application_helper'

module BigPicture
  module ApplicationHelperPatch
    def self.included(base)
      base.send(:prepend, InstanceMethods)
    end

    module InstanceMethods
      def link_to_attachment(attachment, options={})
        use_big_picture = (attachment.is_image? || attachment.is_pdf? || attachment.is_video? || attachment.is_audio?)
        big_picture_link = if options[:download] && use_big_picture
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
                             link_to('', '#', class: 'icon-only icon-zoom-in', :data => { :bp => filename, :caption => filename, :bp_src => bp_src, :url => url }, onclick: 'openBigPicture(this)')
                           else
                             ''
                           end
        big_picture_link.html_safe + super(attachment, options)
      end
    end
  end
end
