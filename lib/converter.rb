 module Keys
 MINERAL_KEY = {
    "silver" => 17,
    "gold" => 14450,
    "iron" => 195.5
  }

  SPACEWORD_TO_ROMAN_KEY = {
    "glob" => "I",
    "prok" => "V",
    "pish" => "X",
    "tegj" => "L"
    }

  ROMAN_TO_NUMBER_KEY = {
    'L' => 50,
    'X' => 10,
    'V' => 5,
    'I' => 1
    }
end

module Run_Converter
  def convert
    get_phrase
    validate_phrase
    prepare_phrase
    grab_mineral
    convert_to_roman
    validate_roman_count
    calculate_space_number
    multiply_mineral
    p return_statement
  end
end

class Converter
  include Keys, Run_Converter
  attr_accessor :phrase, :phrase_array, :space_roman
  def initialize
    @phrase = ""
    @phrase_array = []
    @mineral_multiplier = 0
    @space_roman = ""
    @space_arabic = []
    @space_total = []
    @evaluated_number = 0
    @currency_regex = /pish|glob|tegj|prok|silver|gold|iron/
  end

  def get_phrase
    puts "What would you like to convert?"
    @phrase = gets.downcase.chomp
    validate_phrase
  end

  def validate_phrase
    if @phrase == "how much wood could a woodchuck chuck if a woodchuck could chuck wood?"
      puts "I have no idea what you are talking about"
      get_phrase
    elsif @currency_regex.match(@phrase) == nil
      puts "Please enter a value to be converted"
      get_phrase
    end
  end

  def prepare_phrase
    @phrase.split.each do |word|
      @phrase_array << word.delete(',') if word =~ (@currency_regex)
    end
    @phrase_array
  end

  def grab_mineral
    MINERAL_KEY.each do |mineral, multiply_by|
      if @phrase_array.last == mineral
        @mineral_multiplier += multiply_by
      end
    end
    @mineral_multiplier
  end

  def convert_to_roman
    @phrase_array.each do |word|
      SPACEWORD_TO_ROMAN_KEY.each do |word_key,roman_value|
        if word == word_key
          @space_roman << roman_value
        end
      end
    end
    @space_roman
  end

  def validate_roman_count
    match = @space_roman.match(/MMMM|IIII|CCCC|XXXX/)
    if match != nil
      p "'#{match[0][1]}' cannot be repeat 4 times"
      convert
    end
  end

  def  calculate_space_number
   @space_roman.chars.each_with_index do |char, index|
      next_char = @space_roman[index + 1]
      if next_char && ROMAN_TO_NUMBER_KEY[char] < ROMAN_TO_NUMBER_KEY[next_char]
        @evaluated_number -= ROMAN_TO_NUMBER_KEY[char]
      else
        @evaluated_number += ROMAN_TO_NUMBER_KEY[char]
      end
    end
    @evaluated_number
  end

  def multiply_mineral
    if @mineral_multiplier != 0
      @evaluated_number = ("%g"%(@evaluated_number * @mineral_multiplier)).to_i
    end
  end

  def return_statement
    @phrase = @phrase_array.join(" ")
    if @mineral_multiplier != 0
      "#{@phrase} is #{@evaluated_number} Credits"
    else
      "#{@phrase} is #{@evaluated_number}"
    end
  end
end




### DRIVER ####
#comment out to run rspec
converter = Converter.new
converter.convert

