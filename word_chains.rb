require 'set'

class WordChainer
  def initialize(dictionary)
    @dictionary = File.readlines(dictionary).map(&:chomp).to_set
  end

  def adjacent_words(word)
    same_length = same_length_words(word)

    res = []
    
    same_length.each do |dict_word|
      count = 0
      (word.length).times do |i|
        count += 1 if dict_word[i] != word[i]
      end

      res << dict_word if count == 1
    end

    res
  end

  def same_length_words(word)
    same_length = Set.new
    @dictionary.each do |dict_word| 
      same_length << dict_word if dict_word.length == word.length
    end

    same_length
  end

  def explore_current_words
    new_current_words = []
    @current_words.each do |cur_word|
      adjacent_words(cur_word).each do |adj_word|
        unless @all_seen_words.include?(adj_word)
          new_current_words << adj_word
          @all_seen_words[adj_word] = cur_word
        end
      end
    end

    new_current_words.each do |word|
      puts "#{word} came from #{@all_seen_words[word]}"
    end

    new_current_words
  end

  def build_path(target)
    path = []

    cur_target = target
    until cur_target == "duck"
      path.unshift(target)
      cur_target = @all_seen_words[target]
    end

    p path
  end

  def run(source, target)
    @current_words = [source]
    @all_seen_words = Hash.new { |hash, key| hash[key] = nil }
    @all_seen_words[source]

    until @current_words.empty? || @all_seen_words.include?(target)
      new_current_words = explore_current_words
      
      @current_words = new_current_words
    end

    build_path(target)

  end
end

wc = WordChainer.new("dictionary.txt")
wc.run("duck", "sick")