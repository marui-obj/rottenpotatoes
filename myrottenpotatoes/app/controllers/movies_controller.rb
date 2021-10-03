require 'themoviedb'
class MoviesController < ApplicationController
    before_action :check_for_cancel, :only => [:create, :update]
    before_action :check_for_tmdb, :only => [:create]
    
    def movies_with_filters
        @movies = Movie.with_good_reviews(params[:threshold])
        @movies = @movies.for_kid            if params[:for_kids]
        @movies = @movies.with_many_fans     if params[:with_many_fans]
        @movies = @movies.recently_reviewed  if params[:recently_reviewed]
    end

    def movies_with_filters_2
        # DRYer version
        @movies = Movie.with_good_reviews(params[:threshold])
        %w(for_kid with_many_fans recently_reviewed).each do |filter|
            @movies = @movies.send(filter) if params[filter]
        end
    end

    def index
        @movies = Movie.all.sort_by{ |name| name.title}
        # @movies = Movie.for_kids # for filter kid rating
        # @movies = Movie.with_good_reviews(1..5)
    end
    
    def show
        id = params[:id]
        begin
            @movie = Movie.find(id)

        rescue
            flash[:notice] = "No movie with the given ID could be found."
            redirect_to movies_path
        end

    end

    def new
        @movie = Movie.new
    end

    def create
        @movie = Movie.new(movie_params)
        if @movie.save
            flash[:notice] = "#{@movie.title} was successfully created."
            redirect_to movies_path
        else
            flash[:notice] = "Movie title can't be blank."
            redirect_to new_movie_path
        end
    end

    def search_tmdb
        # hardwire to simulate failure
        flash[:warning] = "'#{params[:search_terms]}' was not found in TMDb."
        redirect_to movies_path
    end

    def edit
        @movie = Movie.find params[:id]
    end

    def update
        @movie = Movie.find(params[:id])
        if @movie.update(movie_params)
            flash[:notice] = "#{@movie.title} was successfully updated."
            redirect_to movie_path(@movie)
        else
            render 'edit'
        end
    end
    
    def destroy
        @movie = Movie.find(params[:id])
        @movie.destroy
        flash[:notice] = "Movie '#{@movie.title}' deleted."
        redirect_to movies_path
    end

    def check_for_cancel
        if (params.key?("create_cancel"))
            flash[:notice] = "Create cancelled"
            redirect_to movies_path
        
        elsif (params.key?("edit_cancel"))
            @movie = Movie.find params[:id]
            flash[:notice] = "Edit cancelled"
            redirect_to movie_path(@movie)
        end 
    end

    def check_for_tmdb
        if params.key?("create_movie")
            @movie_params
            @movie = Movie.new
        end
    end

    def movies_with_filters
        @movies = Movie.with_good_reviews(params[:threshold])
        %w(for_kids with_many_fans recently_reviewed).each do |filter|
            @movies = @movies.send(filter) if params[filter]
        end
    end

    private
        def movie_params
            params.require(:movie).permit(:title, :rating, :release_date, :description)
        end
end
