class AttachmentsController < ItemsController
  skip_filter [:init_new,:find_item,:authorize]
  require_role "admin", :except => "show"
  # GET /attachments
  # GET /attachments.xml
  def index
    @attachments = Attachment.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @attachments }
    end
  end

  # GET /attachments/1
  # GET /attachments/1.xml
  def show
    @attachment = Attachment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @attachment }
    end
  end

  # GET /attachments/new
  # GET /attachments/new.xml
  def new
    @attachment = Attachment.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @attachment }
    end
  end

  # GET /attachments/add
  # GET /attachments/add.xml
  def add
    @attachment = Attachment.new
    @attachment.plain_text_id = params[:text_id]

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @attachment }
    end
  end

  # GET /attachments/1/edit
  def edit
    @attachment = Attachment.find(params[:id])
  end

  # POST /attachments
  # POST /attachments.xml
#  def create
#    @attachment = Attachment.new(params[:attachment])
#    @item = session[:item]
#    @item.resource = @attachment
#    respond_to do |format|
#      if @item.save
#        flash[:notice] = t('message.item.added')
#        format.html {}
#        redirect_to @item.block.page.get_page_path
#      else
#        format.html { render :action => "new" }
#        format.xml  { render :xml => @attachment.errors, :status => :unprocessable_entity }
#      end
#    end
#  end

  def create_single
    @attachment = Attachment.new(params[:attachment])

    respond_to do |format|
      if @attachment.save
        flash[:notice] = t('message.item.added')
        format.html {
          redirect_to( @attachment.plain_text_id.nil? ? :back : @attachment.plain_text.item.block.page.get_page_path) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @attachment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /attachments/1
  # PUT /attachments/1.xml
#  def update
#    @attachment = Attachment.find(params[:id])
#
#    respond_to do |format|
#      if @attachment.update_attributes(params[:attachment])
#        flash[:notice] = 'Attachment was successfully updated.'
#        format.html { redirect_to(@attachment) }
#        format.xml  { head :ok }
#      else
#        format.html { render :action => "edit" }
#        format.xml  { render :xml => @attachment.errors, :status => :unprocessable_entity }
#      end
#    end
#  end

  # DELETE /attachments/1
  # DELETE /attachments/1.xml
  def destroy
    @attachment = Attachment.find(params[:id])
    @attachment.destroy

    respond_to do |format|
      format.html { redirect_to(:back) }
      format.xml  { head :ok }
    end
  end
end
