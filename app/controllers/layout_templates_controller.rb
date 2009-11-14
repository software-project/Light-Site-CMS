class LayoutTemplatesController < ApplicationController
  require_role "admin"
  protect_from_forgery :except => [:new] 
  # GET /layout_templates
  # GET /layout_templates.xml
  def index
    @layout_templates = LayoutTemplate.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @layout_templates }
    end
  end

  # GET /layout_templates/1
  # GET /layout_templates/1.xml
  def show
    @layout_template = LayoutTemplate.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @layout_template }
    end
  end

  # GET /layout_templates/new
  # GET /layout_templates/new.xml
  def new
    @layout_template = LayoutTemplate.new
    
    render :update do |page|
      page.insert_html :top, "dialog_here", :partial => "layout_templates/new",
                       :locals => { :layout_template => @layout_template }
    end
  end

  # GET /layout_templates/1/edit
  def edit
    @layout_template = LayoutTemplate.find(params[:id])
  end

  # POST /layout_templates
  # POST /layout_templates.xml
  def create
    @layout_template = LayoutTemplate.new(params[:layout_template])

    render :update do |page|
      if @layout_template.save
        page.insert_html :bottom, "layout_templates", :partial => "layout_templates/row_form",
                         :locals =>{ :layout_template => @layout_template, :counter => (LayoutTemplate.count + 1) }
#        page.replace ""
      end
    end
  end

  # PUT /layout_templates/1
  # PUT /layout_templates/1.xml
  def update
    @layout_template = LayoutTemplate.find(params[:id])

    respond_to do |format|
      if @layout_template.update_attributes(params[:layout_template])
        flash[:notice] = 'LayoutTemplate was successfully updated.'
        format.html { redirect_to(@layout_template) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @layout_template.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /layout_templates/1
  # DELETE /layout_templates/1.xml
  def destroy
    @layout_template = LayoutTemplate.find(params[:id])
    @layout_template.destroy

    respond_to do |format|
      format.html { redirect_to(layout_templates_url) }
      format.xml  { head :ok }
    end
  end
end
