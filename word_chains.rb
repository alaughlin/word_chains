require 'set'

class WordChainer
  def initialize(dict_file)
    @dictionary = File.readlines(dict_file).map(&:chomp).to_set
  end

  def adjacent_words(word)
    same_length_words = get_same_length(word)

    res = []

    same_length_words.each do |same_length_word|
      count = 0

      (same_length_word.length).times do |i|
        count += 1 if same_length_word[i] != word[i]
      end

      res << same_length_word if count == 1
    end

    res
  end

  def get_same_length(word)
    @dictionary.select { |dict_word| word.length == dict_word.length }
  end

  def explore_current_words
    new_current_words = []

    @current_words.each do |current_word|
      adjacent_words(current_word).each do |adj_word|
        unless @all_seen_words.include?(adj_word)
          new_current_words << adj_word
          @all_seen_words[adj_word] = current_word
        end
      end
    end

    @current_words = new_current_words
  end

  def build_path(target)
    path = []
    current_target = target

    until current_target.nil?
      path.unshift(current_target)
      current_target = @all_seen_words[current_target]
    end

    path
  end

  def run(source, target)
    puts "Finding the path from #{source} to #{target}..."
    @current_words = [source]
    @all_seen_words = { source => nil }

    until @all_seen_words.include?(target)
      explore_current_words
    end

    p build_path(target)
  end
end

wc = WordChainer.new("dictionary.txt")

print "Enter the source word: "
source = gets.chomp
print "Enter the target word: "
target = gets.chomp

wc.run(source, target)