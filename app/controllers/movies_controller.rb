class MoviesController < ApplicationController
  before_filter :redirect_to_stored_search, :only => :index
  after_filter :store_search, :only => :index

  helper_method :ratings_list
  hide_action :ratings_list

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @q = Movie.search params[:q]
    @movies = @q.result
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  protected

  def ratings_list
    @ratings_list ||= %w(G PG PG-13 NC-17 R)
  end

  def redirect_to_stored_search
    if !params[:q] && session[:q]
      redirect_to movies_url(:q => session[:q]) and return false
    end
  end

  def store_search
    session[:q] = params[:q] if params[:q]
  end
end
