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
        @result.each do |t|
            movie = Hash.new
            this_movie = Tmdb::Movie.detail(t["id"])
            
            movie["id"] = this_movie["id"]
            movie["title"] = this_movie["title"]
            movie["release_date"] = this_movie["release_date"]
            movie["rating"] = self.find_rating(this_movie["id"])
            @movies.append(movie)

        end
        @movies
        #flash[:notice] = "#{Tmdb::Movie.releases(@movies[0][""])}"


        # @result
    end

    def find_rating(id)
        detail = Tmdb::Movie.releases(id)
        if detail["countries"].size == 0
            @rating = ""
        else
            detail["countries"].each do |tmp|
                # return tmp.class
                if tmp["iso_3166_1"] === "US"
                    @rating = tmp["certification"]
                end
            end
        end
        @rating
    end

    # new_tmdb.html.haml
    def new_tmdb
        id = params[:id]
        @movie = Hash.new
        this_movie = Tmdb::Movie.detail(id)
        @movie["id"] = this_movie["id"]
        @movie["title"] = this_movie["title"]
        @movie["overview"] = this_movie["overview"]
        @movie["release_date"] = this_movie["release_date"]
        @movie["rating"] = self.find_rating(this_movie["id"])
        @movie
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
            params.require(:movie).permit(:description, :rating, :release_date)
        end

end
