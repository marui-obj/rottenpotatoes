class TmdbController < ApplicationController
    # search_tmdb.html.haml
    def search_tmdb
        @search = Tmdb::Search.new
        @query = params[:search_terms]
        @search.query(@query)
        @result = @search.fetch
        unless @result.empty?
            redirect_to movies_show_tmdb_path(@query)

        else
            # hardwire to simulate failure
            flash[:warning] = "'#{params[:search_terms]}' was not found in TMDb."
            redirect_to movies_path
        end
    end
    
    # show_tmdb.html.haml
    def show_tmdb
        @search = Tmdb::Search.new
        @search.query(params[:title])
        @result = @search.fetch
        @movies = Array.new
        @result.each {|t| @movies.append(Tmdb::Movie.detail(t["id"]))}
        @movies
        # flash[:notice] = "#{@result}"
        # @result
    end

    # new_tmdb.html.haml
    def new_tmdb
        id = params[:id]
        @movie = Tmdb::Movie.detail(id)
    end

    def create
        @movie = Movie.new(movie_params)
        if @movie.save
            flash[:notice] = "#{@movie.title} was successfully created."
            redirect_to movie_path(@movie)
        end
    end

    private
        def movie_params
            params.require(:movie)
        end

end