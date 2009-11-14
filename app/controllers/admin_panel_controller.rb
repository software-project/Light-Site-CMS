class AdminPanelController < ApplicationController
  require_role "admin"
  
  def blogs
    jsonData = ActiveSupport::JSON.decode(params[:blog])
    user = User.find(jsonData['user_id'])
    render :nothing => true , :status => 403 and return if !user
    blog=Blog.find_by_user_id(user.id)
    if blog
      blog.name = jsonData['title']
      blog.description = jsonData['description']
      render :nothing => true, :layout=>false and return if blog.save
    end
    render :nothing => true , :status => 403 and return
  end

  def users
    if !params[:user_id].blank? && !params[:mail].blank?
      user = User.find(params[:user_id])
      user.email = params[:mail]
      unless user.save
        render :nothing => true,:layout=>false, :status => 403 and return
      else
        render :nothing => true,:layout=>false and return
      end

    elsif !params[:user_id].blank? && !params[:blog].blank? && params[:blog] == 'true'
      user = User.find(params[:user_id])
      return_data = Hash.new()  
      if blog=Blog.find_by_user_id(user.id)
        url = url_for :controller => "blogs", :action => "show", :language => blog.language.short_name, :user => user.login
        return_data[:blog]={:blog => true, :title => blog.name, 
          :description => blog.description,
          :link_to_blog => url
          }
      else
        return_data[:blog]={:blog => false}
      end
      
      render :text=>return_data.to_json, :layout=>false and return
    else
      user = User.find(params[:user])
      if Blog.find_by_user_id(user.id)
        blog = 'Tak'
      else
        blog = 'Nie'
      end
      roles = Role.find(:all)
      roles = roles - user.roles
      return_data = Hash.new()
      return_data[:user_roles]= user.roles.collect{|r| {:id => r.id, :name => r.name}}
      return_data[:all_roles]= roles.collect{|r| {:id => r.id, :name => r.name}}
      return_data[:user]= {:id => user.id, :name => user.login,
        :created_at => user.created_at.strftime("%d/%m/%Y"), :mail => user.email,
        :blog => blog,
        :active => user.active?}
      render :text=>return_data.to_json, :layout=>false
    end
  end

  def activate
    User.find(params[:user_id]).activate!
    render :nothing => true
  end

  def deactivate
    user = User.find(params[:user_id])
    if user.has_role?("admin") && Role.find_by_name("admin").users.find_all{|u| u.active? == true}.length == 1
      render :nothing => true, :status => 403 and return
    end
    user.deactivate!
    render :nothing => true
  end

  def destroy_user
    user = User.find(params[:user_id])
    if user.has_role?("admin") && Role.find_by_name("admin").users.find_all{|u| u.active? == true}.length == 1
      render :nothing => true, :status => 403 and return
    end
    user.destroy
    render :nothing => true
  end

  def roles
    if params[:user_id] && params[:roles]
      user = User.find(params[:user_id])
      roles = []
      ActiveSupport::JSON.decode(params[:roles]).each{|r| roles << Role.find_by_name(r)}
      if user.has_role?("admin") && Role.find_by_name("admin").users.find_all{|u| u.active? == true}.length == 1
        render :nothing => true, :status => 403 and return
      end
      user.roles.delete_all
      roles.each{|r| user.roles << r}
    elsif params[:role] && params[:role_action] == 'save'
      role = Role.new(:name => params[:role])
      unless role.save
        render :nothing => true, :status => 403 and return
      else
        response = Hash.new
        response[:id] = role.id
        response[:name] = role.name
        render :text=>response.to_json, :layout=>false and return
      end
    elsif params[:role] && params[:role_action] == 'delete'
      render :nothing => true , :status => 403 and return if params[:role]=='admin'
      role = Role.find_by_name(params[:role])
      role.destroy
    end
    render :nothing => true
    
  end

  def change_password
    return_data = Hash.new()
    return_data[:success]=true
    return_data[:msg]="true"
    if user=User.find(params[:user_id])
      if ((params[:password] == params[:password_confirmation]) && !params[:password_confirmation].blank?)
        user.password_confirmation = params[:password_confirmation]
        user.password = params[:password]
        if user.save!
          render :text=>return_data.to_json, :layout=>false and return
        else
          return_data[:success] = false
          return_data[:msg] = "Zmiana hasła nie powiodła się."
          render :text => return_data.to_json , :status => 403 and return
        end
      else
        return_data[:success] = false
        return_data[:msg] = "Hasła nie są takie same"
        render :text => return_data.to_json 
      end
    else
      render :nothing => true, :status => 403 and return
    end
  end


end
