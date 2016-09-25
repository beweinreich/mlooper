class ConversationsController < ApplicationController
  before_action :set_conversation, only: [:show, :update]
  load_and_authorize_resource except: [:count]
  
  def index
    # @conversations = Conversation.joins(:emails).group(:conversation_id).having('count(emails.id)>10').public_scope.order(updated_at: :desc).page(params[:page])
    @conversations = Conversation.where(featured: true).order(hilarity: :desc).page(params[:page])
  end

  def show
  end

  def count
    render json: Email.all.count
  end

  def update
    respond_to do |format|
      if @conversation.update(conversation_params)
        format.js
        format.json { render [], status: :ok }
      else
        format.js
        format.json { render json: @conversation.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_conversation
      @conversation = Conversation.where(featured: true).find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def conversation_params
      params.require(:conversation).permit(:privacy)
    end
end
