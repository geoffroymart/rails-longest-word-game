require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    # Afficher une liste de X lettres au hasard
    @letters = []
    9.times { @letters << ("A".."Z").to_a.sample }
  end

  def score
    # Récupérer le mot tapé depuis le form
    @word = params[:word].upcase
    @letters = params[:letters]
    # Verifier que ce mot est inclus dans le dico du Wagon
    if english_word?(@word) == false
      then @error = "Your word is not an english word."
      @score = 0
      return false
    # Verifier que ce mot ne contient que des lettres proposees
    elsif in_grid?(@word) == false
      then @error = "Your word contains letters that are not included in the letters given."
      @score = 0
      return false
    # Calculer un score
    else @score = @word.length * 2
    end
  end

  def english_word?(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    user_serialized = URI(url).read
    JSON.parse(user_serialized)["found"]
  end

  def in_grid?(attempt)
    attempt.upcase.split('').all? { |letter| attempt.upcase.count(letter) <= @letters.count(letter) }
  end
end
