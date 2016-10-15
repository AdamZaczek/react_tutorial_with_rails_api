class CommentsController < ApplicationController
  def index
    render(
      status: 200,
      json: Comment.all
    )
  end

  def create
    comment = Comment.new(comment_params)
    if comment.save
      render json: comment, status: 201
    else
      render json: { errors: comment.errors }, status: 422
    end
  end

  private

  def comment_params
    params.permit(:id, :author, :text)
  end

end
