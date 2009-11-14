class GalleryPhotosController < ApplicationController
  def new
#   @photo = GalleryPhoto.new
    @item = Item.find(params[:item])
    render :partial => "galleries/new_photo"
  end

  def edit
    @photo = GalleryPhoto.find(params[:id])
    render :partial => "galleries/edit_photo"
  end

  def create
    @photo = GalleryPhoto.new(params[:gallery_photo])
    if @photo.save
      flash[:notice] = 'Photo was successfully created.'
      redirect_to :back
    else
      render :action => :new
    end
  end

  def update
    @photo = GalleryPhoto.find(params[:id])
    if @photo.update_attributes(params[:gallery_photo])
      flash[:notice] = 'Photo was successfully created.'
      redirect_to :back
    else
      render :action => :new
    end
  end

  def destroy
    @photo = GalleryPhoto.find(params[:id])
    @photo.destroy
    redirect_to :back
  end

end
