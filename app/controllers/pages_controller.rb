class PagesController < ApplicationController
  require_role "admin", :for_all_except => [ :show, :show_date, :show_tag, :tag ],
    :unless => "current_user && current_user.authorized_for_blogging?(params[:user])"
  before_filter :find_page, :only => ['move_up', 'move_down']


  # GET /pages
  # GET /pages.xml
  def index
    @pages = Page.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @pages }
    end
  end

  # GET /pages/1
  # GET /pages/1.xml
  def show
    unless params[:id].nil?
      @page = Page.find_by_param(params[:id])
      @ok = true
    else
      unless params[:name].nil? && params[:language].nil?
        session[:language] = Language.find_by_short_name(params[:language])
        #       @page = Page.find_by_param_and_language_id(params[:name], session[:language].id)
        @page = Page.find_by_param(params[:name], :conditions => ["language_id = ?", session[:language].id])
        @ok = true
      else
        @page = Page.find(:first)
        @ok = false
      end
    end
    if session[:language].nil?
      session[:language] = Language.find(:first)
    end
# Blog controller rendering is disabled   
#    if @page.is_blog and false
#      redirect_to :controller => 'pages', :action => 'blog', :user => User.find(@page.user_id).login, :language => session[:language].short_name and true
#    else
      unless @page.nil?
        @main_position = @page.layout_template.positions.find(:first, :conditions => ["main_position = 1"])
        @items = @page.blocks.find(:first, :conditions => ["position_id = ?",@main_position.id]).items
        if @main_position.page_pagination > 0 and !@items.nil?
          @items = @items.paginate :page => params[:page], :per_page => @main_position.page_pagination, :order => '"order" DESC'
        end
        if @page.redirect.nil?
          respond_to do |format|
            format.html { render :layout => "layouts/"+@page.layout_template.name }
            format.xml  { render :template => @page.layout_template.name }
          end
        else
          redirection = Page.find(@page.redirect)
          unless redirection.nil?
            redirect_to redirection.get_page_path
          else
            redirect_to "/404.html"
          end
        end
      else
        if @ok
          redirect_to "/404.html"
        else
          redirect_to new_page_path
        end
      end
  end

  def blog
    if params[:user].nil?
      @blogs = Page.find(:all, :conditions => ["page_type = blog"])
    else
      @blogs = Page.find(:all, :conditions => ["page_type = blog and user_id = ?", params[:user]])
    end
    unless @blogs.nil?
      @items = []
      unless params[:year].nil?
        unless params[:month].nil?
          start_date = Date.new(params[:year],params[:month],1)
          end_date = start_date.advance(:month => 1)
        else
          start_date = Date.new(params[:year],1,1)
          end_date = start_date.advance(:year => 1)
        end
        @blogs.blocks.each{|block|
          @items += block.items.select{|i| i.created_at >= start_date and i.created_at <= end_date}
        }
      else
        @blogs.blocks.each{|block|
          @items += block.items
        }
      end
      respond_to do |format|
        format.html# show.html.erb
        format.xml  { render :layout => @page.layout_template.name }
      end
    else
      redirect_to :controller => 'pages', :action => 'show'
    end
  end

  def tag
    @items = PlainText.find_tagged_with(params[:tag])

    if params[:language].nil?
      session[:language] = Language.find(:first)
    else
      session[:language] = Language.find_by_short_name(params[:language])
    end
    
    respond_to do |format|
      format.html
    end
  end

  # GET /pages/new
  # GET /pages/new.xml
  def new
    new_object Page.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :layout => "default" }
    end
  end

  # GET /pages/1/edit
  def edit
    @page = Page.find(params[:id])
#    if @page.type == Blog
#      redirect_to :controller => 'blogs', :action => 'edit', :user => User.find(@page.user_id).login
#    end
  end

  # POST /pages
  # POST /pages.xml
  def create
    unless params[:page][:type].nil?
      object = Object.const_get(params[:page][:type])
      @page = object.new(params[:page]) 
    else
      @page = Page.new(params[:page])
    end

    @page.layout_template.positions.each{|p|
      @page.blocks << Block.new(:page_id => @page.id, :position_id => p.id)
    }
    
    @page.slug = Page.escape_permalink(@page.name,"-")
    existing_pages = Page.find(:first, :conditions => ["slug = ?", @page.slug])
    if @page.parent.nil? || @page.parent.children.size == 0
      @page.order = 1
    else
      @page.order = @page.parent.children.size + 1
    end

    respond_to do |format|
      if existing_pages.nil? and @page.save
        flash[:notice] = t('message.page.created')
        if @page.type == "Blog"
          format.html { redirect_to :controller => 'blogs', :action => 'show', :user => User.find(@page.user_id).login, :language => session[:language].short_name and return}
        else
          format.html { redirect_to(@page) }
        end
        format.xml  { render :xml => @page, :status => :created, :location => @page }
      else
        format.xml  { render :xml => @page.errors, :status => :unprocessable_entity }
#        format.html  { render :xml => @page.errors, :status => :unprocessable_entity }
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /pages/1
  # PUT /pages/1.xml
  def update
    @page = Page.find_by_slug(params[:id])

    respond_to do |format|
      if @page.update_attributes(params[:page])
        flash[:notice] = 'Page was successfully updated.'
        format.html { redirect_to @page.get_page_path }
        #        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @page.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /pages/1
  # DELETE /pages/1.xml
  def destroy
    @page = Page.find_by_slug(params[:id])
    @page.destroy

    respond_to do |format|
      format.html { redirect_to(pages_url) }
      format.xml  { head :ok }
    end
  end

  def admin_on_off
    if session[:admin].nil? || session[:admin]== :on
      session[:admin] = :off
    else
      session[:admin] = :on
    end
    redirect_to :back
  end

  def move_down
    parent = @page.parent
    unless parent.nil?
      lower = parent.lower_item(@page.order)
    end
    unless(lower.nil?)
      tmp_order = lower.order
      lower.order = @page.order
      @page.order = tmp_order

      respond_to do |format|
        if @page.save && lower.save
          flash[:notice] = t('message.item.updated')
          format.html { redirect_to :back }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @page.errors, :status => :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        flash[:notice] = t('message.item.unmovable')
        format.html { redirect_to :back }
      end
    end
  end

  def move_up
    parent = @page.parent
    unless parent.nil?
      higher = parent.higher_item(@page.order)
    end
    unless(higher.nil?)
      tmp_order = higher.order
      higher.order = @page.order
      @page.order = tmp_order
      respond_to do |format|
        if @page.save && higher.save
          flash[:notice] = t('message.item.updated')
          format.html { redirect_to :back }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @page.errors, :status => :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        flash[:notice] = t('message.item.unmovable')
        format.html { redirect_to :back }
      end
    end
  end

  private
  def find_page
    @page = Page.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  protected
  def new_object(page)
    @page = page
    @page.language_id = params[:language_id]
    @page.parent_id = params[:parent_id]

    if session[:language].nil?
      session[:language] = Language.find(:first)
    end

    unless params[:connector].nil?
      @page.connector = params[:connector]
    else
      tmp_page = Page.find(:first, :order => "connector DESC")
      unless tmp_page.nil?
        @page.connector = tmp_page.connector + 1
      else
        @page.connector = 1
      end
    end
  end
end
