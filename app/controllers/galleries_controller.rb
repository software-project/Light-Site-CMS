class GalleriesController < ItemsController
  skip_filter [:init_new,:find_item,:authorize]
  require_role "admin", :except => "show"

  def show
    @gallery = Gallery.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @gallery }
    end
  end

  def new
    @gallery = Gallery.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @gallery }
    end
  end

  # GET /plain_texts/1/edit
  def edit
    @gallery = Gallery.find(params[:id])
  end

end
