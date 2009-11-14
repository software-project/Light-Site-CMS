class ExtensionTypesController < ApplicationController
  require_role "admin"
  # GET /extension_types
  # GET /extension_types.xml
  def index
    @extension_types = ExtensionType.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @extension_types }
    end
  end

  # GET /extension_types/1
  # GET /extension_types/1.xml
  def show
    @extension_type = ExtensionType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @extension_type }
    end
  end

  # GET /extension_types/new
  # GET /extension_types/new.xml
  def new
    @extension_type = ExtensionType.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @extension_type }
    end
  end

  # GET /extension_types/1/edit
  def edit
    @extension_type = ExtensionType.find(params[:id])
  end

  # POST /extension_types
  # POST /extension_types.xml
  def create
    @extension_type = ExtensionType.new(params[:extension_type])

    respond_to do |format|
      if @extension_type.save
        flash[:notice] = 'ExtensionType was successfully created.'
        format.html { redirect_to(@extension_type) }
        format.xml  { render :xml => @extension_type, :status => :created, :location => @extension_type }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @extension_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /extension_types/1
  # PUT /extension_types/1.xml
  def update
    @extension_type = ExtensionType.find(params[:id])

    respond_to do |format|
      if @extension_type.update_attributes(params[:extension_type])
        flash[:notice] = 'ExtensionType was successfully updated.'
        format.html { redirect_to(@extension_type) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @extension_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /extension_types/1
  # DELETE /extension_types/1.xml
  def destroy
    @extension_type = ExtensionType.find(params[:id])
    @extension_type.destroy

    respond_to do |format|
      format.html { redirect_to(extension_types_url) }
      format.xml  { head :ok }
    end
  end
end
