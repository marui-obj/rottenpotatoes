require 'rails_helper'

describe MoviesController  do
    describe 'delete movie'do
        before :each do
        @movietest2=FactoryGirl.create(:movie)
        end
        it 'delete movie' do
          expect{delete:destroy,params: {id: @movietest2.id}}.to change(Movie,:count).by(-1)
        end
        it 'home page'do
          delete:destroy,params:{id: @movietest2.id}
          expect(response).to redirect_to(:action=>'index')
        end

      end

      describe 'add movie' do
        before :each do
         @movietest={movie:{:title=>'My title',:rating=>'NR',:release_date=>'04-10-2000',:description=>'My description'}}
        end
        it 'new movie' do
          expect{post:create,params:@movietest}.to change(Movie,:count).by(1)
        end
      end

      describe 'edit movie'do 
        before :each do
          @movietest2=FactoryGirl.create(:movie)
        end
        it 'edit movie' do
          get :edit,params:{id: @movietest2.id}
          expect(assigns(:movie).description)==('My description')
        end
        it 'detail page'do
          post :show,params:{id: @movietest2.id}
          expect(response).to render_template('show')
        end
      end


end


