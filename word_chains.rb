require 'set'

class WordChainer
	def initialize(dictionary)
		@dictionary = File.readlines(dictionary).map(&:chomp).to_set
		p adjacent_words("that")
	end

	def adjacent_words(word)
		same_length_words = Set.new
		@dictionary.each do |dict_word| 
			same_length_words << dict_word if dict_word.length == word.length
		end

		res = []
		
		same_length_words.each do |dict_word|
			count = 0
			
			(word.length).times do |i|
				count += 1 if dict_word[i] != word[i]
			end

			res << dict_word if count == 1
		end

		res
	end
end

wc = WordChainer.new("dictionary.txt")