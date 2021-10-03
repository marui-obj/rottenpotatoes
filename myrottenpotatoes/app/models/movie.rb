class Movie < ActiveRecord::Base
    has_many :reviews
    has_many :moviegoers, :through => :reviews
    def self.all_ratings ; %w[U G PG PG-13 R UR NR NC-17 X GP M M/PG None] ; end
    validates :title, :presence => true
    # validates :release_date, :presence => true
    # validate :released_1930_or_later #We can custom validator
    validates :rating, :inclusion => {:in => Movie.all_ratings},
        :unless => :grandfathered?
    
    def released_1930_or_later
        errors.add(:release_date, 'must be 1930 or later') if
            release_date && release_date < Date.parse('1 Jan 1930')
    end

    @@grandfathered_date = Date.parse('1 Nov 1968')
    def grandfathered?
        release_date && release_date < @@grandfathered_date
    end

    scope :with_good_reviews, lambda { |threshold|
        Movie.joins(:reviews).group(:movie_id).
          having(['AVG(reviews.potatoes) > ?', threshold.to_i])
    }
    scope :for_kids, lambda {
        Movie.where('rating in (?)', %w(G PG))
    }
end
