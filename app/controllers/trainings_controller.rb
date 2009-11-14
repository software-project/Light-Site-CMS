class TrainingsController < ItemsController
  skip_filter [:init_new,:find_item,:authorize]
  require_role "admin", :except => "show"
  
  # GET /trainings/1
  # GET /trainings/1.xml
  def show
    @training = Training.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @training }
    end
  end

  # GET /trainings/new
  # GET /trainings/new.xml
  def new
    @training = Training.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @training }
    end
  end

  # GET /trainings/1/edit
  def edit
    @training = Training.find(params[:id])
  end

  def add_module
    if request.get?
      @item = Training.find(params[:id])
      @training_module = TrainingModule.new
  #    render :update do |page|
  #        page.insert_html :after, "add_module", :partial => "trainings/module_form"
  #    end
      render :partial => "trainings/new_module", :locals => {:training_module => @training_module, :training => @item.id}
    else
      @training_module = TrainingModule.new(params[:training_module])
      @training_module.save
      redirect_to :back
    end
  end

  def delete_module
    @training_module = TrainingModule.find(params[:id])
    tr_id = @training_module.id
    @training_module.destroy

    render :update do |page|
        page["training_module_#{tr_id}"].replace ""
    end
  end

  def edit_module
    if request.get?
      @training_module = TrainingModule.find(params[:id])
      render :partial => "trainings/edit_module", :locals => {:training_module => @training_module}
    else
      @training_module = TrainingModule.find(params[:id])
      @training_module.update_attributes(params[:training_module])
      redirect_to :back
    end
  end
  
  def add_event
    if request.get?
      @training_module = TrainingModule.find(params[:id])
      @training_module_event = TrainingModuleEvent.new
      render :partial => "trainings/add_event", :locals => {:training_module => @training_module, :training_module_event => @training_module_event}
    else
      @training_module_event = TrainingModuleEvent.new(params[:training_module_event])
      @training_module_event.save
      redirect_to :back
    end
  end

  def edit_event
    if request.get?
      @training_module_event = TrainingModuleEvent.find(params[:id])
      render :partial => "trainings/edit_event", :locals => {:training_module_event => @training_module_event}
    else
      @training_module_event = TrainingModuleEvent.find(params[:id])
      @training_module_event.update_attributes(params[:training_module_event])
      redirect_to :back
    end
  end

  def delete_event
    @training_module_event = TrainingModuleEvent.find(params[:id])
    tr_id = @training_module_event.id
    @training_module_event.destroy

    render :update do |page|
        page["event_#{tr_id}"].replace ""
    end
  end
  


end
