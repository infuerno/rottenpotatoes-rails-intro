class MoviesController < ApplicationController
  attr_reader :order, :selected_ratings

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    if params['ratings']
      @movies = Movie.where({:rating => params['ratings'].keys })
      @selected_ratings = params['ratings']
    else
      @movies = Movie.all
      @selected_ratings = Movie.all_ratings
    end

    # only title and release_date are valid for sorting
    # need to do explicity or ensure we restrict it
    if params[:order] == "title"
      @movies.order! :title
      @order = :title
    elsif params[:order] == "release_date"
      @movies.order! :release_date        
      @order = :release_date
    end
  end

  def new
    # default: render 'new' template
  end

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

end
