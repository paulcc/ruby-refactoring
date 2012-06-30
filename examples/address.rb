class Address < ActiveRecord::Base
  
  def initialize address_line1, address_line2, city, postcode
    
    hash = {
      :address1 => address_line1,
      :address2 => address_line2, 
      :city => city, 
      :postcode => postcode}
    
    super(hash)

  end
  
end
