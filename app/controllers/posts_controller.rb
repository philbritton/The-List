class PostsController < ApplicationController

  skip_before_filter :require_login, :only => :index

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post
      .joins("LEFT JOIN votes ON posts.id = votes.post_id")
      .select("posts.id," +
        "sum(if(direction = 0, 1, if(direction is null, 0, -1))) as score," +
        "posts.created_at," +
        "url," +
        "title," +
        "posts.user_id," +
        "comment_count")
      .group("posts.id")
      .order("log10(abs(sum(if(direction = 0, 1, if(direction is null, 0, -1)))) + 1) * sign(sum(if(direction = 0, 1, if(direction is null, 0, -1)))) + (unix_timestamp(posts.created_at) / 300000) DESC")
      .limit(10)
    

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.find(params[:id])

    upvotes = Vote.group(:post_id).where(:post_id => @post.id, :direction => 0).count[@post.id] || 0
    downvotes = Vote.group(:post_id).where(:post_id => @post.id, :direction => 1).count[@post.id] || 0

    @score = upvotes - downvotes
    
    @comment = Comment.new

    if current_user
      if Vote.where(:user_id => current_user.id, :post_id => @post.id, :direction => 0).count > 0
        @active = ' upactive'
      elsif Vote.where(:user_id => current_user.id, :post_id => @post.id, :direction => 1).count > 0
        @active = ' downactive'
      end
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/new
  # GET /posts/new.json
  def new
    @post = Post.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(params[:post].merge(:user_id => current_user.username))

    respond_to do |format|
      if @post.save

        User.find(current_user.id).update_attributes({
      	  :karma => current_user.karma - 10
    	  })

        format.html { redirect_to @post }
        format.json { render json: @post, status: :created, location: @post }
      else
        format.html { render action: "new" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.json
  def update
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.update_attributes(params[:post])
        format.html { redirect_to @post }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :no_content }
    end
  end

  def recent
    @posts = Post.order('created_at DESC').limit(10)
  end
end
