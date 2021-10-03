require 'rails_helper'

describe MoviesController, :type => :controller do
    describe 'searching TMDb' do
      before :each do
        @fake_results = [double('movie1'), double('movie2')]
      end
      it 'calls the model method that performs TMDb search' do
        expect(Movie).to receive(:find_in_tmdb).with('hardware').and_return(@fake_results)
          post :search_tmdb, params: {:search_terms => 'hardware'}
      end

      describe 'after valid search' do
        before :each do
          allow(Movie).to receive(:find_in_tmdb).and_return(@fake_results)
          post :search_tmdb, params: {:search_terms => 'hardware'}
        end
      it 'makes the TMDb search results available to that template' do
        expect(assigns(:movies)).to eq(@fake_results)
      end

      describe 'delete movie'do
        before :each do
        @movietest2=FactoryGirl.create(:movie)
        end
        it 'Delete Movie' do
          expect{delete:destroy,params: {id: @movietest2.id}}.to change(Movie,:count).by(-1)
        end
        it 'Home page'do
          delete:destroy,params:{id: @movietest2.id}
          expect(response).to redirect_to(:action=>'index')
        end

      end

      describe 'create movie' do
        before :each do
         @movietest={movie:{:title=>'a',:rating=>'G',:release_date=>'01-04-2000',:description=>'eiei'}}
        end
        it 'New Movie' do
          expect{post:create,params:@movietest}.to change(Movie,:count).by(1)
        end
      end

      describe 'edit movie'do 
        before :each do
          @movietest2=FactoryGirl.create(:movie)
        end
        it 'edit movie' do
          get :edit,params:{id: @movietest2.id}
          expect(assigns(:movie).description)==('eiei')
        end
        it 'detail page'do
          post :show,params:{id: @movietest2.id}
          expect(response).to render_template('show')
        end
      end


      
      it 'selects the Search Results template for rendering' do
        expect(response).to render_template('tmdb_result')
      end
    end
  end
end