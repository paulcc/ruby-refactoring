class Picture < ActiveRecord::Base

	#belongs_to :article
  has_attached_file :data,
    :styles => { :standard => "480x480^" },
    :url => "/article_images/:id/:style/:basename.:extension",
    :path => "/article_images/:id/:style/:basename.:extension",
    
    :storage => :s3,
    :s3_credentials => "#{Rails.root}/config/aws.yml",
    # "canned" S3 access policy
    :s3_permissions => "authenticated-read",
    :bucket => "flockedu_images"
    
  validates_attachment_presence :picture
  validates_attachment_content_type :picture, :content_type => ["image/jpeg", "image/png", "image/bmp", "image/tiff", "image/pjpeg", "image/x-png", "image/jpg"]
end
