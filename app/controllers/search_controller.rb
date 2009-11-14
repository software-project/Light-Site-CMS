class SearchController < ApplicationController
  def index
    @results = PlainText.search(params[:search], params[:page])
  end

end
