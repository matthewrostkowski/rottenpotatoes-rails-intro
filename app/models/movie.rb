class Movie < ApplicationRecord
  def self.all_ratings
    %w[G PG PG-13 R]
  end

  def self.with_ratings(ratings_list)
    return all if ratings_list.blank?
    where('UPPER(rating) IN (?)', ratings_list.map(&:upcase))
  end
end
