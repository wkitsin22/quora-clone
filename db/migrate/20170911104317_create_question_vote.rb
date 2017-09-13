class CreateQuestionVote < ActiveRecord::Migration[5.0]
	def change
		create_table :questionvotes do |t|
			t.belongs_to :user 
			t.belongs_to :question 
			t.boolean :votes, :default => true 
		end 
	end
end
