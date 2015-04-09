class Product < ActiveRecord::Base
	#set_primary_key "id"
	#self.primary_key = [:id]
	belongs_to :rubric
end
