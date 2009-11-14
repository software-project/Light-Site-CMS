class SubeventsController < ApplicationController
  skip_filter [:init_new,:find_item,:authorize]
  require_role "admin"
  before_filter :find_event, :only => ['new']
  # GET /subevents
  # GET /subevents.xml
  def index
    @subevents = Subevent.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @subevents }
    end
  end

  # GET /subevents/1
  # GET /subevents/1.xml
  def show
    @subevent = Subevent.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @subevent }
    end
  end

  # GET /subevents/new
  # GET /subevents/new.xml
  def new
    @subevent = Subevent.new
    @subevent.event = @event

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @subevent }
    end
  end

  # GET /subevents/1/edit
  def edit
    @subevent = Subevent.find(params[:id])
  end

  # POST /subevents
  # POST /subevents.xml
  def create
    @subevent = Subevent.new(params[:subevent])

    respond_to do |format|
      if @subevent.save
        flash[:notice] = t('message.item.added')
        format.html {redirect_to @subevent.event.item.block.page.get_page_path.to_s + "?edit=#{@subevent.event.item.id}"}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @subevent.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /subevents/1
  # PUT /subevents/1.xml
  def update
    @subevent = Subevent.find(params[:id])

    respond_to do |format|
      if @subevent.update_attributes(params[:subevent])
        flash[:notice] = t('message.item.updated')
        format.html { redirect_to @subevent.event.item.block.page.get_page_path }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @subevent.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /subevents/1
  # DELETE /subevents/1.xml
  def destroy
    @subevent = Subevent.find(params[:id])
    @subevent.destroy

    respond_to do |format|
      format.html { redirect_to :back }
      format.xml  { head :ok }
    end
  end

  private
  def find_event
    @event = Event.find(params[:event])
    rescue ActiveRecord::RecordNotFound
      render_404
  end
end
