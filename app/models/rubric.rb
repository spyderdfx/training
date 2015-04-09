class Rubric < ActiveRecord::Base
	#set_primary_key "id"
	self.primary_key = "id"
  has_many :products
end
