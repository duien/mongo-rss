# HotnessSignature provides a Bayesian analysis of text "hotness."  A given
# signature is owned by a single user, and trained over time with text that
# user reads, and how much the system thinks the user liked that text.  It will
# then attempt to predict how much a user will like any other given piece of
# text.

require 'mongomapper'
require ''

class HotnessSignature
  include MongoMapper::EmbeddedDocument

  belongs_to :user
  key :word_hotness, Hash

  def after_create # :nodoc:
    word_hotness = Hash.new(0)

    @options = {
      :language => 'en',
      :encoding => 'UTF_8'
    }
  end

  # Train the signature with a particular corpus of text.  The weight should be
  # how "hot" this text is considered - for particularly awesome text, set the
  # weight high, and for mediocre text set it low.  The actual values don't
  # matter so much as long as "high" is higher than "low".
  #
  def train (text, weight)
    word_hash(text).each do |word, count|
      word_hotness[word] += (count * weight)
    end
  end

  # Return a hotness score for a given corpus of text, based on previous
  # training.
  #
  def predicted_hotness (text)
    score = 0
    total = category_words.values.sum
    word_hash(text).each do |word, count|
      s = word_hotness.has_key?(word) ? category_words[word] : 0.1
      score += Math.log(s/total.to_f)
    end

    return score
  end

  private

  # Turn a corpus of text in to a hash of word frequencies.
  #
  def word_hash ( text )
    words = text.gsub(/[^\w\s]/,"").split + text.gsub(/[\w]/," ").split
    stemmer = Lingua::Stemmer.new(@options)
    d = Hash.new
    skip_words = SKIP_WORDS[@options[:language]] || []
    words.each do |word|
      word = word.mb_chars.downcase.to_s if word =~ /[\w]+/
        key = stemmer.stem(word).intern
      if word =~ /[^\w]/ || ! skip_words.include?(word) && word.length > 2
        d[key] ||= 0
        d[key] += 1
      end
    end
    return d
  end

  SKIP_WORDS = [
        "a",
        "again",
        "all",
        "along",
        "are",
        "also",
        "an",
        "and",
        "as",
        "at",
        "but",
        "by",
        "came",
        "can",
        "cant",
        "couldnt",
        "did",
        "didn",
        "didnt",
        "do",
        "doesnt",
        "dont",
        "ever",
        "first",
        "from",
        "have",
        "her",
        "here",
        "him",
        "how",
        "i",
        "if",
        "in",
        "into",
        "is",
        "isnt",
        "it",
        "itll",
        "just",
        "last",
        "least",
        "like",
        "most",
        "my",
        "new",
        "no",
        "not",
        "now",
        "of",
        "on",
        "or",
        "should",
        "sinc",
        "so",
        "some",
        "th",
        "than",
        "this",
        "that",
        "the",
        "their",
        "then",
        "those",
        "to",
        "told",
        "too",
        "true",
        "try",
        "until",
        "url",
        "us",
        "were",
        "when",
        "whether",
        "while",
        "with",
        "within",
        "yes",
        "you",
        "youll",
        ]

end
