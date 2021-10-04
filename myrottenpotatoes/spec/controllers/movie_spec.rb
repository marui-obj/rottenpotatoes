require 'rails_helper'

describe Movie, :type => :request do
  describe 'check' do
    fixtures :movies
    it 'includes rating and year in full name'  do
      movie = movies(:milk_movie)
      expect("#{movie.title} (#{movie.rating})") == 'Milk (R)'
      # expect("Milk (R)") == 'Milk (R)'
    end
    it 'can do the same thing using a factory' do 
      # 'build' creates but doesn't save object; 'create' also saves it
      movie = FactoryGirl.build(:movie, :title => 'Milk', :rating => 'R')
      expect("#{movie.title} (#{movie.rating})").to eq 'Milk (R)'
    end
    
  end
end