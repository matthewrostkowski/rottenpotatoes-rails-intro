class MoviesController < ApplicationController
  def show
    @movie = Movie.find(params[:id])
  end

  def index
    @all_ratings     = Movie.all_ratings
    @ratings_to_show = params[:ratings]&.keys || @all_ratings

    # Only allow safe sort keys we expect
    allowed_sorts = %w[title release_date]
    @sort_by = allowed_sorts.include?(params[:sort_by]) ? params[:sort_by] : nil

    scope = Movie.with_ratings(@ratings_to_show)
    @movies = @sort_by ? scope.order(@sort_by) : scope
  end

  def new; end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end