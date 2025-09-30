class MoviesController < ApplicationController
  def show
    @movie = Movie.find(params[:id])
  end

  def index
    @all_ratings     = Movie.all_ratings
    chosen_ratings = params[:ratings]&.keys
    chosen_sort = params[:sort_by]
    if chosen_ratings.blank? && chosen_sort.blank? && (session[:ratings].present? || session[:sort_by].present?)
        redirect_to movies_path(
      ratings: (session[:ratings] || @all_ratings).index_with { '1' },
      sort_by: session[:sort_by]
        ) and return
    end

  @ratings_to_show = chosen_ratings.presence || @all_ratings
  @sort_by         = %w[title release_date].include?(chosen_sort) ? chosen_sort : nil

  session[:ratings] = @ratings_to_show
  session[:sort_by] = @sort_by

  @movies = Movie.with_ratings(@ratings_to_show)
  @movies = @movies.order(@sort_by) if @sort_by.present?

  end


  def new; end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find(params[:id])
  end

  def update
    @movie = Movie.find(params[:id])
    @movie.update!(movie_params)
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
