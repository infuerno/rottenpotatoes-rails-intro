class MoviesController < ApplicationController
  attr_reader :order, :selected_ratings

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    @movie = Movie.find(params[:id])
  end

  def index
    # check if any keys in the session are not in the params, need to be to be RESTful
    new_params = Hash.new
    [:ratings, :order].each do | k | 
      if session[k] and !params[k]
        new_params[k] = session[k]
      end
    end
    if new_params.length > 0
      logger.debug "Params in session but not in URI, redirecting to correct URI (RESTful)"
      logger.debug "New params: #{new_params}"
      redirect_to movies_path(new_params.merge!(params))
    end

    if params[:ratings]
      @movies = Movie.where({:rating => params[:ratings].keys })
      @selected_ratings = params[:ratings]
      session[:ratings] = params[:ratings]
    else
      @movies = Movie.all
      @selected_ratings = Movie.all_ratings
    end

    if ["title", "release_date"].include? params[:order]
      @movies.order! params[:order]
      @order = params[:order]
      session[:order] = params[:order]
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
