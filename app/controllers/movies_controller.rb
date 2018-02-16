class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    #Initialize this so index.html.haml can create button for each rating
    @all_ratings = ['G','PG','PG-13','R']

     #Check to see if clicked params were title or release date, change css and ordering of Movie respectively
     if params[:key] == 'title'
       @title_css = 'hilite'
       @movies = Movie.order(title: :asc)
     elsif params[:key] == 'release_date'
       @release_css = 'hilite'		
       @movies = Movie.order(release_date: :asc)
     else
       #If we got here the user may or may not have clicked refresh with some boxes checked. First, check to see if they wanted to filter based on rating
       if (params[:ratings].nil?)
         @movies = Movie.all
       else
       #Grab the keys [NOT VALUES] from params[:ratings] to find desired ratings, and display movies
       #where the rating is found in the keys
       @rating_filter = params[:ratings].keys
       @movies = Movie.where(rating: @rating_filter)
       end
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
