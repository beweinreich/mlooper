class ReplacementsController < ApplicationController
  before_action :set_replacement, only: [:destroy]
  load_and_authorize_resource

  def create
    @replacement = Replacement.new(replacement_params)
    @replacement.user_id = current_user.id

    respond_to do |format|
      if @replacement.save(replacement_params)
        format.js
      else
        format.js
      end
    end
  end

  def destroy
    @replacement.destroy
    respond_to do |format|
      format.js
    end
  end

  private
    def set_replacement
      @replacement = Replacement.find(params[:id])
    end

    def replacement_params
      params.require(:replacement).permit(:word, :replacement_word)
    end
end
