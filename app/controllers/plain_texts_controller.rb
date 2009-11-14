class PlainTextsController < ItemsController
  skip_filter [:init_new,:find_item,:authorize]
  require_role "admin", :except => "show"

  # GET /plain_texts/1
  # GET /plain_texts/1.xml
  def show
    @plain_text = PlainText.find(params[:id])
    params[:name] = @plain_text.item.block.page.slug

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @plain_text }
    end
  end
  
  # GET /plain_texts/new
  # GET /plain_texts/new.xml
  def new
    @plain_text = PlainText.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @plain_text }
    end
  end

  # GET /plain_texts/1/edit
  def edit
    @plain_text = PlainText.find(params[:id])
  end

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

end
