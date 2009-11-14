class UsersController < ApplicationController
  require_role "admin"
  protect_from_forgery :except => [:add_user] 
  # Be sure to include AuthenticationSystem in Application Controller instead
  

  # render new.rhtml
  def new
    @user = User.new
  end
  
  def index
    @users = User.find(:all)
        return_data = Hash.new()
        return_data[:users]= @users.collect{|u| {:id => u.id, :name => u.login}}
        render :text=>return_data.to_json, :layout=>false
  end
  
  def create
#    logout_keeping_session!
    @user = User.new(params[:user])

    success = @user && @user.save

    if success && @user.errors.empty?
      redirect_back_or_default('/')
      flash[:notice] = "Thanks for signing up!  We're sending you an email with your activation code."
    else
      flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
      render :action => 'new'
    end
  end

  def activate
#    logout_keeping_session!
    user = User.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    case
    when (!params[:activation_code].blank?) && user && !user.active?
      user.activate!
      flash[:notice] = "Signup complete! Please sign in to continue."
      redirect_to '/login'
    when params[:activation_code].blank?
      flash[:error] = "The activation code was missing.  Please follow the URL from your email."
      redirect_back_or_default('/')
    else 
      flash[:error]  = "We couldn't find a user with that activation code -- check your email? Or maybe you've already activated -- try signing in."
      redirect_back_or_default('/')
    end
  end

  def activate(activation_code)
#    logout_keeping_session!
    user = User.find_by_activation_code(activation_code) unless activation_code.blank?
    case
    when (!params[:activation_code].blank?) && user && !user.active?
      user.activate!
      flash[:notice] = "Signup complete! Please sign in to continue."
      return true
    end
    return false
  end

  def activate_user
    @user = User.find(params[:id])
    @user.activate!
    render :update do |page| 
      page.replace "user_#{@user.id}", :partial => "users/user", :locals => {:user => @user, :counter => User.count}
    end
  end

  def add_user
    if request.post?
      @user = User.new(params[:user])
      success = @user && @user.save
      if success && @user.errors.empty?
        flash[:notice] = "Thanks for signing up!  We're sending you an email with your activation code."
        render :update do |page|
          page.insert_html :bottom, "users_table", :partial => "users/user", :locals => {:user => @user, :counter => User.count+ 1}
          page << "$('#add_user').dialog('close');"
          page << "$('#add_user').remove();"          
        end
      else
        flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
        render :update do |page|
           page.insert_html :top, "user_errors", :partial => "shared/error_div", :locals => {:errors => @user.errors}
        end
      end
    else
      @user = User.new
      render :update do |page|
        page.insert_html :top, "new_user_dialog_here", :partial => "users/new",
                         :locals => { :user => @user }
      end
    end
  end

  def edit_user
    if request.post?
      @user = User.find(params[:id])
      success = @user && @user.update_attributes(params[:user])

      if success && @user.errors.empty?
        render :update do |page|
          page.replace "user_#{@user.id}", :partial => "users/user", :locals => {:user => @user, :counter => User.count + 1}
          page << "$('#edit_user').dialog('close');"
          page << "$('#edit_user').remove();"   
        end
      else
        render :update do |page|
           page.insert_html :top, "user_errors", :partial => "shared/error_div", :locals => {:errors => @user.errors}            
        end
      end
    else
      @user = User.find(params[:id])
      render :update do |page|
        page.insert_html :top, "new_user_dialog_here", :partial => "users/edit",
                         :locals => { :user => @user }
      end
    end
  end

  def delete
    @user = User.find(params[:id])
    user_id = @user.id
    if User.count == 1 || Role.find(:first, :conditions => ["name = 'admin'"]).users.count <= 1 and @user.roles.any?{|role| role.name.eql?("admin") }
      render :update do |page|
        page.insert_html :top, "user_admin_errors", :partial => "shared/error_div", :locals =>{:errors => [t("cant_remove_this_element")]}
        page << "$('#user_admin_errors').fadeIn('slow').animate({opacity: 1.0}, 3000).fadeOut('slow', function() {$(this).html('');});"           
      end
    else
      @user.destroy
      render :update do |page|
          page.replace "user_#{user_id}",""
      end      
    end
  end

  def assign_role
    @user = User.find(params[:id])
    @role = Role.find(params[:role_id].split('_').last())
    unless @user.roles.any?{|role| role.name.eql?(@role.name)}
      @user.roles << @role
      @user.save
      render :update do |page|
        page.insert_html :top, "user_roles_#{@user.id}", :partial => "users/user_role", :locals => {:user => @user, :role => @role}
      end
    else
      render :update do |page|
          page["user_#{@user.id}_role_#{@role.id}"].visual_effect :highlight
      end
    end
  end

  def remove_role
    @user = User.find(params[:id])
    @role = Role.find(params[:role_id])
    unless Role.find(:first, :conditions => ["name = 'admin'"]).users.count <= 1
      @user.roles.delete(@role)
      if @user.save
        render :update do |page|
          page["user_#{@user.id}_role_#{@role.id}"].replace ""
        end
      end
    else
      render :update do |page|
        page.insert_html :top, "user_admin_errors", :partial => "shared/error_div", :locals =>{:errors => [t("cant_remove_this_element")]}
        page << "$('#user_admin_errors').fadeIn('slow').animate({opacity: 1.0}, 3000).fadeOut('slow', function() {$(this).html('');});"
      end
    end
  end

  def add_role
    if request.post?
      @role = Role.new(params[:role])
      success = @role && @role.save
      if success && @role.errors.empty?
        render :update do |page|
          page.insert_html :bottom, "roles_table", :partial => "users/role", :locals => {:role => @role, :counter => Role.count + 1}
          page << "$('#add_role').dialog('close');"
          page << "$('#add_role').remove();"
        end
      else
        render :update do |page|
           page.insert_html :top, "role_errors", :partial => "shared/error_div", :locals => {:errors => @role.errors}
        end
      end
    else
      @role = Role.new
      render :update do |page|
        page.insert_html :top, "new_user_dialog_here", :partial => "users/new_role",
                         :locals => { :role => @role }
      end
    end
  end

  def edit_role
    if request.post?
      @role = Role.find(params[:id])
      success = @role && !@role.name.eql?("admin") && @role.update_attributes(params[:role])

      if success && @role.errors.empty?
        render :update do |page|
          page.replace "role_#{@role.id}", :partial => "users/role", :locals => {:role => @role, :counter => Role.count + 1}
          page << "$('#edit_role').dialog('close');"
          page << "$('#edit_role').remove();"
          page["role_#{@role.id}"].visual_effect :highlight
        end
      else
        render :update do |page|
           page.insert_html :top, "role_errors", :partial => "shared/error_div", :locals => {:errors => @role.errors}
        end
      end
    else
      @role = Role.find(params[:id])
      render :update do |page|
        page.insert_html :top, "new_user_dialog_here", :partial => "users/edit_role",
                         :locals => { :role => @role }
      end
    end
  end

  def delete_role
    @role = Role.find(params[:id])

    unless @role.name.eql? "admin"
      role_id = @role.id
      @role.destroy
      render :update do |page|
        page["role_#{role_id}"].replace "" 
      end
    else
      render :update do |page|
        page.insert_html :top, "user_admin_errors", :partial => "shared/error_div", :locals =>{:errors => [t("cant_remove_this_element")]}
        page << "$('#user_admin_errors').fadeIn('slow').animate({opacity: 1.0}, 3000).fadeOut('slow', function() {$(this).html('');});"
      end
    end
  end

end
