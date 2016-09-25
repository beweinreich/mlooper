class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update]
  load_and_authorize_resource :except => [:confirm]

  def show
    if @user == current_user
      @conversations = current_user.conversations
    else
      @conversations = @user.conversations.public_scope
    end
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.js
      else
        format.js
      end
    end
  end

  def confirm
    # @user = User.last
    # @first_email = Email.first
    @user = User.confirm_by_token(params[:confirm_token])
    @reset_token = params[:reset_token]
    if @user.errors.empty?
      @first_email = @user.conversations.first.emails.last
      @first_email.update(send_at: Time.now.utc+1.hour)
      respond_to do |format|
        format.html
      end
    else
      redirect_to root_url, :alert => "Your confirmation token is invalid."
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:privacy)
    end
end
