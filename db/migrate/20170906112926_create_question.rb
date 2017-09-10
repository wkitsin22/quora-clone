class CreateQuestion < ActiveRecord::Migration[5.0]
	def change
		create_table :questions do |t|
			t.belongs_to :user 
			t.string :question 
		end 
	end
end
