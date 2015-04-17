class CommentsController < ApplicationController
  before_action :set_comment, only: [:edit, :update, :destroy]
  load_and_authorize_resource
  
  
  def new
    @child_comment = Comment.new(
      parent_id: params[:parent_id], 
      commentable_id: params[:post_id])
    respond_to do |format|
      format.html { render :partial => 'comments/new', 
        :object => @child_comment, :as => 'comment' }
    end
  end

  def create
    post = Post.find(params[:comment][:commentable_id])
    @comment = Comment.build_from(post, current_user.id, params[:comment][:body])
    respond_to do |format|
      if @comment.save
        if is_children?
          format.html { render :partial => "comments/child_comment",
            locals: { comment: @comment }, :status => :created }
        else
          format.html { render :partial => "comments/comment", 
            locals: { comment: @comment, post_id: @comment.commentable_id }, 
            :status => :created }
        end
      else
        format.html { redirect_to :back, norice: 'Something went wrong.' }
        format.json { render json: comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    render partial: 'comments/new', :object => @comment, :as => 'comment'
  end

  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.json { render json: @comment }
      else
        format.html { redirect_to :back }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end 

  def destroy
    respond_to do |format|
      if @comment.destroy
         format.json { render json: @comment }
      else
        format.html { redirect_to :back, notice: 'Post was successfully destroyed.' }
      end
    end
  end

  private

    def set_comment
      @comment = Comment.find(params[:id])
    end

    def comment_params
      params.require(:comment).permit(:id, :body, :commentable_id, :parent_id)
    end

    def is_children?
      parent_id = params[:comment][:parent_id]
      unless parent_id.empty?
        parent_comment = Comment.find(parent_id)
        @comment.move_to_child_of(parent_comment)
        true
      else
        false
      end
    end
end