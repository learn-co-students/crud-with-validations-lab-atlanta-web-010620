class Song < ApplicationRecord
    validates :title, presence: true
    validate :no_repeat_titles
    validates :released, inclusion: { in: [ true, false ] }
    validates :release_year, presence: true, if: :released
    validate :release_year_not_in_future
    validates :artist_name, presence: true
    

    def no_repeat_titles
        songs = Song.all.select{|song| song.artist_name == self.artist_name && song.release_year == self.release_year}
        if songs.select{|song| song.title == self.title}.any? 
        errors.add(:title, "Can't make two songs with the same title in one year")
        end
    end

    def release_year_not_in_future
        if released && release_year
            if release_year > Date.today.year
                errors.add(:release_year, "Can't be in the future")
            end
        end
    end
end
