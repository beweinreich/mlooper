class PagesController < ApplicationController
  skip_authorization_check
  
	def home
		# @conversations = Conversation.joins(:emails).group(:conversation_id).having('count(emails.id)>10').public_scope.order(updated_at: :desc).page(params[:page])
		@conversations = Conversation.where(featured: true).order(hilarity: :desc).page(params[:page])
		render "conversations/index"
	end
	
end