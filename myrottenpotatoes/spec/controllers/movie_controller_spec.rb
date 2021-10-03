require 'rails_helper'

describe MoviesController  do
    
    describe "searching TMDb" , :type => :controller do
        before :each do
            @fake_results = [double('movie1'), double('movie2')]
            end
        it 'calls the model method that performs TMDb search' do
        expect(Movie).to receive(:find_in_tmdb).with('hardware').
            and_return(@fake_results)
        post :search_tmdb, params: {:search_terms => 'hardware'}
        end
    end
    describe "P2"  ,:type => :request  do
        # before :each do
        #     allow(Movie).to receive(:find_in_tmdb).and_return(@fake_results)
        #     post :search_tmdb, params:{:search_terms => 'hardware'}
        # end
        # it 'selects the Search Results template for rendering' do
        #     expect(response).to render_template('search_tmdb')
        # end

    it 'make the TMDb search results available to that template'
    end
end
