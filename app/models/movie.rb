class Movie < ActiveRecord::Base
	# class method
	def self.all_ratings
		Movie.select(:rating).uniq.map{ |x| x.rating }
	end	
end
