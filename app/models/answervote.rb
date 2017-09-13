class Answervote < ActiveRecord::Base 

  def self.total_vote(answer_id)
  	self.where(answer_id: answer_id, votes: true).count - self.where(answer_id: answer_id, votes: false).count 
  end

end 
