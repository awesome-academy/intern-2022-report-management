class CommentsController < ApplicationController
  before_action :require_login

  def create
    @comment = current_user.comments.build comment_params
    @status = @comment.save
    respond_to do |format|
      format.html{redirect_to manager_reports_path}
      format.js
    end
  end

  private

  def comment_params
    params.permit Comment::COMMENT_PARAMS
  end
end
