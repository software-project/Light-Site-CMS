class CommentsController < ApplicationController
  def new
    @comment = Comment.new(params[:comment])
    render :update do |page|
      if @comment.save
        page.insert_html :top , "comments_for_#{@comment.commentable_id}",
                         :partial => "comments/comment", :locals => {:comment => @comment, :counter => @comment.commentable.comments.size}
        page["comment_#{@comment.id}"].visual_effect :highlight, :duration => 2.0
      end
    end
  end

  def delete

    @comment = Comment.find(params[:id])
    comment_id = @comment.id
    @comment.destroy
    render :update do |page|
        page["comment_#{comment_id}"].visual_effect :blind_up
    end
  end

end
