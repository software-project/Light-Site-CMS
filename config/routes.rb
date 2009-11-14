ActionController::Routing::Routes.draw do |map|

#          :url =>{ :controller => "comments", :action => "new"}
  map.with_options :controller => "comments" do |comments|
    comments.with_options :conditions => {:method => :post} do |comments|
      comments.connect "comments/new/:item",
                     :controller => "comments",
                     :action => "new"
      comments.connect "comments/delete/:id",
                     :controller => "comments",
                     :action => "delete"
    end
  end

  map.with_options :controller => "users" do |users|
    users.with_options :conditions => {:method => :post} do |users|
      users.connect "users/add_user",
                     :controller => "users",
                     :action => "add_user"
      users.connect "users/delete/:id",
                     :controller => "users",
                     :action => "delete"
      users.connect "users/edit_user/:id",
                     :controller => "users",
                     :action => "edit_user"
      users.connect "users/activate_user/:id",
                     :controller => "users",
                     :action => "activate_user"
      users.connect "users/assign_role/:id/:role_id",
                    :controller => "users",
                    :action => "assign_role",
                    :requirements => { :id => /\d+/, :role_id => /\d+/ }
      users.connect "users/remove_role/:id/:role_id",
                    :controller => "users",
                    :action => "remove_role",
                    :requirements => { :id => /\d+/, :role_id => /\d+/ }
      users.connect "users/delete_role/:id",
                    :controller => "users",
                    :action => "delete_role"
      users.connect "users/add_role",
                    :controller => "users",
                    :action => "add_role"
      users.connect "users/edit_role/:id",
                    :controller => "users",
                    :action => "edit_role"
    end
    users.with_options :conditions => {:method => :get} do |users|
      users.connect "users/add_user",
                     :controller => "users",
                     :action => "add_user"
      users.connect "users/edit_user/:id",
                     :controller => "users",
                     :action => "edit_user"
      users.connect "users/add_role",
                    :controller => "users",
                    :action => "add_role"
      users.connect "users/edit_role/:id",
                    :controller => "users",
                    :action => "edit_role"
    end
  end


  map.connect "/ajax_map",
              :controller => "locations",
              :action => "ajax_map"

  map.with_options :controller => "trainings" do |trainings|
    trainings.with_options :conditions => {:method => :post} do |trainings|
      trainings.connect "/trainings/add_module/:id",
                        :controller => "trainings",
                        :action => "add_module"
      trainings.connect "/trainings/delete_module/:id",
                        :controller => "trainings",
                        :action => "delete_module"
      trainings.connect "/trainings/edit_module/:id",
                        :controller => "trainings",
                        :action => "edit_module"
      trainings.connect "/trainings/add_event",
                        :controller => "trainings",
                        :action => "add_event"
      trainings.connect "/trainings/edit_event/:id",
                        :controller => "trainings",
                        :action => "edit_event"
      trainings.connect "/trainings/delete_event/:id",
                        :controller => "trainings",
                        :action => "delete_event"
    end
    trainings.with_options :conditions => {:method => :get} do |trainings|
      trainings.connect "/trainings/add_module",
                        :controller => "trainings",
                        :action => "add_module"
      trainings.connect "/trainings/edit_module/:id",
                        :controller => "trainings",
                        :action => "edit_module"
      trainings.connect "/trainings/add_event",
                        :controller => "trainings",
                        :action => "add_event"
      trainings.connect "/trainings/edit_event/:id",
                        :controller => "trainings",
                        :action => "edit_event"
    end
  end

  map.resources :trainings


  map.with_options :controller => 'ckfinder' do |ckfinder|
    # GET METHOD
    ckfinder.with_options :conditions => {:method => :get} do |ckfinder|
      ckfinder.connect "/browser/get_folders",
        :controller => 'ckfinder',
        :action => "get_folders"
    end
    ckfinder.with_options :conditions => {:method => :post} do |ckfinder|
      ckfinder.connect "/browser/quick_upload",
        :controller => 'ckfinder',
        :action => "quick_upload"
    end
  end

  map.resources :galleries
  map.resources :gallery_photos
  map.connect "/gallery_photos/create",
    :controller => "gallery_photos",
    :action => "create"
  map.connect "/gallery_photos/update/:id",
    :controller => "gallery_photos",
    :action => "update"
  map.connect "/gallery_photos/edit/:id",
    :controller => "gallery_photos",
    :action => "edit"

#  map.resources :blog_date_menus
  map.with_options :controller => 'pages' do |pages|
    pages.with_options :conditions => {:method => :get} do |pages|
      pages.connect '/blog/:language/:user/:year/:month',
        :requirements => { :year => /(19|20)\d\d/, :month => /[0-1]?\d/,:language => /([A-Z][A-Z])/ },
        :user =>  nil,
        :year => nil,
        :month => nil,
        :controller => "pages",
        :action => 'blog'
      pages.connect '/blog/:language/:user/:year/:month/:day/:id',
        :requirements => { :year => /(19|20)\d\d/, :month => /[0-1]?\d/ , :day => /[0-3]?\d/, :language => /([A-Z][A-Z])/},
        :controller => "pages",
        :action => 'blog_post'
      pages.connect '/tag/:tag/:language',
        :requirements => { :language => /([A-Z][A-Z])/, :tag => /\w+/ },
        :language => nil,
        :controller => "pages",
        :action => "tag"                    
    end
  end

  map.resources :news
  map.resources :locations
  map.resources :attachments
  map.connect "/attachment/add",
    :controller => "attachments",
    :action => "add"

  map.resources :subevents
  map.resources :events
  map.resources :quotas
  map.connect "/quota/add",
    :controller => "quotas",
    :action => "add"

  map.resources :layout_templates
  map.connect "/layout_templates/new",
              :controller => "layout_templates",
              :action => "new",
              :method => :post

  map.resources :plain_texts

  map.resources :menus

  map.resources :extension_types
  map.resources :items
  map.connect "items/move_up/:id",
    :controller => "items",
    :action => "move_up",
    :requirements => { :id => /\d+/ }
  map.connect "items/move_down/:id",
    :controller => "items",
    :action => "move_down",
    :requirements => { :id => /\d+/ }
  map.connect "items/change_status/:id/:status_id",
    :controller => "items",
    :action => "change_status",
    :requirements => {  :id => /\d+/,
                        :status_id => /[1-3]/ }

#  map.resources :positions
  map.with_options :controller => 'positions' do |positions|
    positions.connect "/positions/new/:layout_template_id",
                :controller => "positions",
                :action => "new",
                :requirements => { :layout_template_id => /\d+/ }

    positions.connect "/positions/edit/:id",
                :controller => "positions",
                :action => "edit"

    positions.connect "/positions/change_pagination/:id/:pagination",
                :controller => "positions",
                :action => "change_pagination",
                :method => :post,
                :requirements => { :pagination => /\d+/ }

    positions.connect "/positions/change_main_position/:id",
                :controller => "positions",
                :action => "change_main_position",
                :method => :post
  end


  map.resources :languages

  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate', :activation_code => nil
  map.resources :users
  map.seach '/search', :controller => 'search', :action => 'index'

  map.resource :session

  map.connect "/:language/:name",
    :controller => "pages",
    :action => "show",
    :requirements => { :language => /([A-Z][A-Z])/ }

  map.connect "pages/move_up/:id",
    :controller => "pages",
    :action => "move_up",
    :requirements => { :id => /\d+/ }
  map.connect "pages/move_down/:id",
    :controller => "pages",
    :action => "move_down",
    :requirements => { :id => /\d+/ }
  map.connect "/admin_on_off",
    :controller => "pages",
    :action => "admin_on_off"
#  map.connect "/:language/blog/:user",
#    :controller => "blogs",
#    :action => "show",
#    :requirements => { :language => /([A-Z][A-Z])/ }
#  map.connect "/:language/blog/:user/:tag",
#    :controller => "blogs",
#    :action => "show_tag",
#    :requirements => { :language => /([A-Z][A-Z])/ }
#  map.connect "blog/:user",
#    :controller => "blogs",
#    :action => "show"
#
#  map.connect "/blog/new/:user",
#    :controller => "blogs",
#    :action => "new"
#
#  map.connect "/blog/create/:user",
#    :controller => "blogs",
#    :action => "create"
#
#  map.connect "/blog/edit/:user",
#    :controller => "blogs",
#    :action => "edit"
#
#  map.connect "/blog/update/:user",
#    :controller => "blogs",
#    :action => "update"
#
#  map.resources :blog_texts
#  map.resources :blogs
  map.resources :pages

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "pages", :action => "show"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
