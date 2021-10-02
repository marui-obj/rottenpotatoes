class ReviewsController < ApplicationController
<<<<<<< HEAD
    before_action :has_moviegoer_and_movie, :only => [:new, :create, :edit, :destroy]
    before_action :set_movie_review, :only => [:edit, :update, :destroy]
    before_action :check_for_cancel, :only => [:create, :update]
    protected
    def has_moviegoer_and_movie
        unless @current_user
            flash[:warning] = 'You must be logged in to create a review.'
            redirect_to login_path
        end

        unless (@movie = Movie.find_by(:id => params[:movie_id]))
            flash[:warning] = 'Review must be for an existing movie.'
            redirect_to movies_path
        end
    end
    public
    def new
        @review = @movie.reviews.build
    end
    def create
        @current_user.reviews << @movie.reviews.build(review_params)
        redirect_to movie_path(@movie)
    end
 
    def edit
    end

    def update
      @review.update!(review_params)
      redirect_to movie_path(@movie)
    end

    def destroy
      @review.destroy
      flash[:notice] = "Movie #{@movie.title} review #{@review.id} deleted."
      redirect_to movies_path(@movie)
    end

    private
    def review_params
        params.require(:review).permit(:potatoes)
    end
    
    def set_movie_review
      @movie = Movie.find_by_id(params[:movie_id])
      @review = Review.find_by_id(params[:id])
    end
    def check_for_cancel
      if (params.key?("create_cancel"))
          flash[:notice] = "Create review cancelled"
          redirect_to movies_path(@movie)
      
      elsif (params.key?("edit_cancel"))
          flash[:notice] = "Edit review cancelled"
          redirect_to movie_path(@movie)
      end
    end
end
