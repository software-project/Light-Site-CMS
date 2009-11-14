# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # AuthenticatedSystem must be included for RoleRequirement, and is provided by installing acts_as_authenticates and running 'script/generate authenticated account user'.
  include AuthenticatedSystem
  # You can move this into a different controller, if you wish.  This module gives you the require_role helpers, and others.
  include RoleRequirementSystem
  
  before_filter :set_locale

  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery :secret => '72ec195107480d2949ae3eac1cabc257'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password

    private

  # Set the locale
  def set_locale
    unless params[:language].nil?
      I18n.locale= params[:language].downcase
      session[:language] = Language.find_by_short_name(params[:language])
    else
      I18n.locale= "pl"
      session[:language] = Language.find_by_short_name("pl")
    end
  end
end
