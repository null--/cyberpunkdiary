class TagsController < ApplicationController
  def index
    @tags = Tag.all
  end

  def show
    @tag = Tag.find( params[:id] )
    @total = @tag.articles.count

    @perpage = 6
    @page = (params[:page] || '1').to_i;

    @articles = @tag.articles.find(:all, :limit => @perpage, :offset => (@page - 1) * @perpage);

    @n_page = @total / @perpage;
    @n_page = @n_page + 1 if @n_page * @perpage != @total
  end
end
