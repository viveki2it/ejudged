class Photo < ActiveRecord::Base
  belongs_to :entry
  attr_accessible :photo, :photo_file_name, :photo_content_type, :photo_file_size

  #paperclip
  
  has_attached_file :photo,
                :styles => {
                :thumb=> "100x100#",
                :small  => "400x400>"
            },
            :url  => "/assets/user_photos/:id/:style/:id.:extension",
            :path => ":rails_root/public/assets/user_photos/:id/:style/:id.:extension"
end
