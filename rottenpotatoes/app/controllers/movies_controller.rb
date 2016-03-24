class MoviesController < ApplicationController

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "Created the movie #{@movie.title}."
    redirect_to movies_path
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' removed."
    redirect_to movies_path
  end

  def show
    id = params[:id]
    @movie = Movie.find(id)
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "Updated #{@movie.title}."
    redirect_to movie_path(@movie)
  end

  def index
    sort = params[:sort] || session[:sort]

    case sort
    when 'title'
      ordering,@title_header = {:order => :title}, 'hilite'
    when 'release_date'
      ordering,@date_header = {:order => :release_date}, 'hilite'
    end

    @all_ratings = Movie.all_ratings

    @selected_ratings = params[:ratings] || session[:ratings] || {}
    if @selected_ratings == {}
      @selected_ratings = Hash[@all_ratings.map {|rating| [rating, rating]}]
    end

    if params[:sort] != session[:sort]
      session[:sort] = sort
      flash.keep
      redirect_to :sort => sort, :ratings => @selected_ratings and return
    end

    if params[:ratings] != session[:ratings] and @selected_ratings != {}
      session[:sort] = sort
      session[:ratings] = @selected_ratings
      flash.keep
      redirect_to :sort => sort, :ratings => @selected_ratings and return
    end
    @movies = Movie.where(rating: @selected_ratings.keys).all
  end

  def new
  end

  def findWithSameDirector
    @movie = Movie.find params[:id]

    @director = @movie.director
    if @director == nil || @director == ""
      redirect_to movies_path
      return
    end

    @movies = Movie.where(director: @director).all
  end

end
