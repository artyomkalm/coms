class Post < ActiveRecord::Base
	belongs_to :user
	acts_as_commentable

	def get_comments
      self.root_comments.includes(:user).includes(:children).order("created_at DESC")
    end
end
