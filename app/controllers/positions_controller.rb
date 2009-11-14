class PositionsController < ApplicationController
  require_role "admin"
  protect_from_forgery :except => [:new] 


  # GET /positions/new
  # GET /positions/new.xml
  def new
    @position = Position.new
    @position.layout_template_id = params["layout_template_id"]

    render :update do |page|
      page.insert_html :top, "dialog_here", :partial => "positions/new",
                       :locals => { :position => @position }
    end
  end

  # GET /positions/1/edit
  def edit
    @position = Position.find(params[:id])
    if request.get?
      render :update do |page|
        page.insert_html :top, "dialog_here", :partial => "positions/edit",
                         :locals => { :position => @position }
      end
    else
      if @position.update_attributes(params[:position])
        render :update do |page|
          page["position_row_#{@position.id}"].replace :partial => "positions/row_form",
                           :locals => {:position => @position, :counter => LayoutTemplate.find(:all).index(@position.layout_template)}
          page << "$('#edit_position').dialog('close');"
          page << "$('#edit_position').remove();"
          page["position_row_#{@position.id}"].visual_effect :highlight
        end
      else
        render :update do |page|
            page.insert_html :top, "position_errors", :partial => "shared/error_div", :locals => {:errors => [@position.errors]} 
        end
      end
    end
  end


  # POST /positions
  # POST /positions.xml
  def create
    @position = Position.new(params[:position])
    positions = Position.find(:all, :conditions => ["layout_template_id = ?",params[:position][:layout_template_id]])
    if positions.size == 0
      @position.main_position = true
    else
      @position.main_position = false
    end

    render :update do |page|
      if @position.save
        page.insert_html :after, "layout_template_#{@position.layout_template_id}", :partial => "positions/row_form",
                         :locals => {:position => @position, :counter => LayoutTemplate.find(:all).index(@position.layout_template)}
      end
    end
  end


  # DELETE /positions/1
  # DELETE /positions/1.xml
  def destroy
    @position = Position.find(params[:id])

    if @position.layout_template.positions.count > 1 && !@position.main_position
      position_id = @position.id
      @position.destroy
      render :update do |page|
        page["position_row_#{position_id}"].replace ""
      end
    else
      render :update do |page|
        page.insert_html :top, "layouts_errors",:partial => "shared/error_div", :locals => {:errors => [t("cant_delete_main_panel")]}
        page << "$('#layouts_errors').fadeIn('slow').animate({opacity: 1.0}, 3000).fadeOut('slow', function() {$(this).html('');});" 
      end
    end
  end

  def change_pagination
    @position = Position.find(params[:id])
    errors = []
    page_pagination_tmp = @position.page_pagination
    if @position.main_position
      @position.page_pagination = params[:pagination]
      if @position.save
        render :update do |page|

        end
        return
      else
        errors << @position.errors
      end
    else
      @position.errors.add(t("cant_change_this_element"))
    end
    render :update do |page|
      page.insert_html :top, "layouts_errors",:partial => "shared/error_div", :locals => {:errors => @position.errors}
      page << "$('#layouts_errors').fadeIn('slow').animate({opacity: 1.0}, 3000).fadeOut('slow', function() {$(this).html('');});" 
      page << "$('#page_position_pagination_#{@position.id}').val('#{page_pagination_tmp}')"
    end
  end

  def change_main_position
    @position = Position.find(params[:id])
    old_main_pos = @position.layout_template.main_position
    old_main_pos.main_position = false
    @position.main_position = true
    if @position.save && old_main_pos.save
      index = LayoutTemplate.find(:all).index(@position.layout_template)
      render :update do |page|
        page["position_row_#{@position.id}"].replace :partial => "positions/row_form",
                           :locals => {:position => @position, :counter => index}
        page["position_row_#{old_main_pos.id}"].replace :partial => "positions/row_form",
                           :locals => {:position => old_main_pos, :counter => index}
      end
    else
      render :update do |page|
        page.insert_html :top, "layouts_errors",:partial => "shared/error_div", :locals => {:errors => @position.errors + old_main_pos.errors}
        page << "$('#layouts_errors').fadeIn('slow').animate({opacity: 1.0}, 3000).fadeOut('slow', function() {$(this).html('');});"
      end
    end
  end

end
