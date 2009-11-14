class CkfinderController < ApplicationController
  require_role "admin"
  helper Ckfinder::CkfinderHelper
  include Ckfinder::CkfinderHelper
  protect_from_forgery :except => [:quick_upload]

  
  def get_folders
    items = get_all_items
    render :partial => "ckfinder/get_folders", :locals => {:items => items}
  end


  def quick_upload
    @attachment = Attachment.new
    @attachment.uploaded_data = params[:upload]

    respond_to do |format|
      if @attachment.save
        format.js {
          responds_to_parent do
            render :update do |page|
              page << "CKEDITOR.tools.callFunction(#{params[:CKEditorFuncNum]}, '#{@attachment.public_filename}');"
            end
          end
        }
      end
    end
  end
end
