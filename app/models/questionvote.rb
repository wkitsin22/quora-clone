class Questionvote < ActiveRecord::Base 
  def self.total_vote(question_id)
  	self.where(question_id: question_id, votes: true).count - self.where(question_id: question_id, votes: false).count 
  end
end 