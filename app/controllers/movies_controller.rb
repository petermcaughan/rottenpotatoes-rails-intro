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
    puts "here"
    @all_ratings = ['G','PG','PG-13','R']

     #Check to see if clicked params were title or release date, change css and ordering of Movie respectively
      #If user selected a particular mode of sorting, override this to be the new remembered session setting
       if params[:key] == 'title'
         session[:title] = true
         session[:release_date] = false
         session[:ratings] = false
         @title_css = 'hilite'
         @movies = Movie.order(title: :asc)
       elsif params[:key] == 'release_date'
         session[:title] = false
         session[:release_date] = true
         session[:ratings] = false
         @release_css = 'hilite'		
         @movies = Movie.order(release_date: :asc)
       else
       #If we got here the user may or may not have clicked refresh with some boxes checked. First, check to see if they wanted to filter based on rating
         if (params[:ratings].nil?)
          #If we got here, no user input since last settings configuration. we need to check for any remembered settings.
           if session[:title] == true
            @title_css = 'hilite'
            @movies=Movie.order(title: :asc)
           elsif session[:release_date] == true
            @release_css = 'hilite'
            @movies=Movie.order(release_date: :asc)
           elsif session[:ratings] == true
            @ratings_filter = session[:ratings_keys]
            @movies = Movie.where(rating: @ratings_filter)
           else
            @movies = Movie.all
          end
         else
       #Grab the keys [NOT VALUES] from params[:ratings] to find desired ratings, and display movies
       #where the rating is found in the keys
          #Update the session settings to remember which ratings you sort by
         @rating_filter = params[:ratings].keys
         session[:ratings_keys] = params[:ratings].keys
         session[:ratings] = true
         session[:title] = false
         session[:release_date] = false
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
