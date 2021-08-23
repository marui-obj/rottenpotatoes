class MoviesController < ApplicationController
    before_action :check_for_cancel, :only => [:create, :update]
    def index
        @movies = Movie.all.sort_by{ |name| name.title}
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
        @movie = Movie.create!(params[:movie].permit(:title,:description,:rating,:release_date))
        flash[:notice] = "#{@movie.title} was successfully created."
        redirect_to movie_path(@movie)
    end

    def edit
        @movie = Movie.find params[:id]
    end

    def update
        @movie = Movie.find params[:id]
        permitted = params[:movie].permit(:title,:description,:rating,:release_date)
        @movie.update(permitted)
        flash[:notice] = "#{@movie.title} was successfully updated."
        redirect_to movie_path(@movie)
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
end
