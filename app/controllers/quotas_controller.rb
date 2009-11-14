class QuotasController < ApplicationController
  skip_filter [:init_new,:find_item,:authorize]
  require_role "admin"
  # GET /quotas
  # GET /quotas.xml
  def index
    @quotas = Quota.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @quotas }
    end
  end

  # GET /quotas/1
  # GET /quotas/1.xml
  def show
    quotas = Quota.find(:all, :conditions => ["language_id = ?", session[:language].id])

    @quota = quotas[rand(quotas.size)]

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @quota }
    end
  end

  # GET /quotas/new
  # GET /quotas/new.xml
  def new
    @quota = Quota.find(:first)
    unless @quota.nil?
      @item = session[:item]
      @item.resource = @quota
      respond_to do |format|
        if @item.save
          flash[:notice] = t('message.quotas.created')
          format.html { redirect_to @item.block.page.get_page_path }
#          format.xml  { render :xml => @quota, :status => :created, :location => @quota }
        end
      end
    else
      flash[:notice] = t('message.quotas.no_qouta_create_one')
      redirect_to :action => "add"
    end
  end

  # GET /quotas/new
  # GET /quotas/new.xml
  def add
    @quota = Quota.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @quota }
    end
  end

  # GET /quotas/1/edit
  def edit
    @quota = Quota.find(params[:id])
  end

  # POST /quotas
  # POST /quotas.xml
  def create
    @quota = Quota.new(params[:quota])
    respond_to do |format|
      if @quota.save
        flash[:notice] = t('message.quotas.created')
        format.html { redirect_to "/" }
#        format.xml  { render :xml => @quota, :status => :created, :location => @quota }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @quota.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /quotas/1
  # PUT /quotas/1.xml
  def update
    @quota = Quota.find(params[:id])

    respond_to do |format|
      if @quota.update_attributes(params[:quota])
        flash[:notice] = 'Quota was successfully updated.'
        format.html { redirect_to(@quota) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @quota.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /quotas/1
  # DELETE /quotas/1.xml
  def destroy
    @quota = Quota.find(params[:id])
    @quota.destroy

    respond_to do |format|
      format.html { redirect_to(quotas_url) }
      format.xml  { head :ok }
    end
  end
end
