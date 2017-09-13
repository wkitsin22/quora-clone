class CreateAnswerVote < ActiveRecord::Migration[5.0]
	def change
		create_table :answervotes do |t|
			t.belongs_to :user 
			t.belongs_to :question 
			t.belongs_to :answer
			t.boolean :votes, :default => true 
		end 
	end
end
