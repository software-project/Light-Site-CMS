class ItemsController < ApplicationController
  before_filter :init_new, :only => ['new']
  before_filter :find_item, :only => ['move_up', 'move_down', 'change_status', 'destroy', 'show', 'edit']
  before_filter :authorize, :except => ['show']
  after_filter :redirect_back, :only => ['move_up', 'move_down']

  # GET /items
  # GET /items.xml
  def index
    @items = Item.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @items }
    end
  end

  # GET /items/1
  # GET /items/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @item }
    end
  end

  # GET /items/new
  # GET /items/new.xml
  def new
#    extension_type = ExtensionType.find(params[:item][:extension_type_id])
#    @item = Item.new
#    @item.block_id = params[:block]
#    @item.extension_type_id = extension_type.id
#    @item.user_id = current_user
#    @item.status = Status.find_by_name("Development")
    tmpitems = @item.block.items
    if !tmpitems.nil? && tmpitems.length > 0
      @item.order = tmpitems.sort_by{|i| i.order}.last.order + 1
      @item.connector = params[:connector] || tmpitems.sort_by{|i| i.connector}.last.connector + 1
    else
      @item.order = 1
      @item.connector = 1
    end

    session[:item] = @item
    session[:extension_type] = @extension_type

    redirect_to :controller => @extension_type.controller_name, :action => :new

#    respond_to do |format|
#      format.html # new.html.erb
#      format.xml  { render :xml => @item }
#    end
  end

  # GET /items/1/edit
  def edit
  end

  # POST /items
  # POST /items.xml
  def create
    extension = Object.const_get(class_name)
    extension_type = session[:extension_type]
    @extension = extension.new(params[extension_type.controller_name.singularize.to_sym])

    @item = session[:item]
    @item.resource = @extension
    
    respond_to do |format|
      if @item.save
        flash[:notice] = t('message.item.added')
        format.html {}
        redirect_to @item.block.page.get_page_path
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @extension.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /items/1
  # PUT /items/1.xml
  def update
    extension = Object.const_get(class_name(params))
    extension_type = session[:extension_type]

    @item = extension.find(params[:id])

    respond_to do |format|
      if @item.update_attributes(params[extension_type.controller_name.singularize.to_sym])
        flash[:notice] = t('message.item.updated')
        format.html { redirect_to @item.item.block.page.get_page_path }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.xml
  def destroy
    url = @item.block.page.get_page_path
    @item.destroy

    respond_to do |format|
      format.html { redirect_to url }
      format.xml  { head :ok }
    end
  end

  def move_down
    block = @item.block
    lower = block.lower_item(@item.order)
    unless(lower.nil?)
      tmp_order = lower.order
      lower.order = @item.order
      @item.order = tmp_order
    
      respond_to do |format|
        if @item.save && lower.save
          flash[:notice] = t('message.item.updated')
          format.html { redirect_to :back }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @item.errors, :status => :unprocessable_entity }
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
    block = @item.block
    higher = block.higher_item(@item.order)
    unless(higher.nil?)
      tmp_order = higher.order
      higher.order = @item.order
      @item.order = tmp_order    
      respond_to do |format|
        if @item.save && higher.save
          flash[:notice] = t('message.item.updated')
          format.html { redirect_to :back }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @item.errors, :status => :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
          flash[:notice] = t('message.item.unmovable')
        format.html { redirect_to :back }
      end
    end
  end

  def change_status
    @item.status = Status.find(params[:item][:status_id])
    respond_to do |format|
      if @item.update_attributes(params[:item])
        flash[:notice] = t('message.item.updated')
        format.html { redirect_to :back }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @item.errors, :status => :unprocessable_entity }
      end
    end
  end

  private
  def authorize
      if @item.resource.nil?
        session[:extension_type] = @item.extension_type
        obj = Kernel.const_get(class_name).new
         if obj.respond_to?(:authorize) && obj.authorize(@item, current_user)
           return true
         end
      elsif @item.resource.respond_to?(:authorize) && @item.resource.authorize(@item, current_user)
        true
      elsif current_user.has_role?('admin')
        true
      else
        redirect_to  :controller => "pages", :action => "show" 
      end
  end

  def init_new
    @extension_type = ExtensionType.find(params[:item][:extension_type_id])
    @item = Item.new
    @item.block_id = params[:block]
    @item.extension_type_id = @extension_type.id
    @item.user_id = current_user.id
    @item.status = Status.find_by_name("Development")
  end

  def find_item
    @item = Item.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render_404
  end

  def redirect_back
  end

  def class_name(params = [])
    if params.size == 0
      extension_type = session[:extension_type]
      tab = []
      extension_type.controller_name.singularize.gsub(/_/, ' ').scan(/\w+/).each{ |i|
        tab += [i.capitalize]
      }
      return tab.to_s
    else
      params.keys.each{|k|
        ExtensionType.find(:all).each{|et|
          if et.controller_name.singularize == k
            session[:extension_type] = et
            return class_name
          end
        }
      }
    end
  end

end
