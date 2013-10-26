require "spec_helper"
require "converter"

describe Converter do
  let(:converter) { Converter.new }

  context "#get_phrase" do
    it "accepts user input" do
      converter.stub(:gets) {"how many credits is glob prok"}
      STDOUT.should_receive(:puts).with("What would you like to convert?")
      converter.get_phrase.should == converter.validate_phrase
    end
  end

  context "#prepare_phrase" do
    it "removes unnecessary words" do
      converter.phrase << "how much is glob prok silver"
      converter.prepare_phrase.should == ["glob", "prok", "silver"]
    end
  end


  context "#grab_mineral" do
    it "grabs and converts mineral to multiplier" do
      converter.phrase << "how much is glob prok silver"
      converter.prepare_phrase
      converter.grab_mineral.should == 17
    end
  end

  context "#convert_to_roman" do
    it "converts glob to I" do
     converter.phrase_array << "glob"
     converter.convert_to_roman.should == "I"
   end

   it "converts prok to V" do
     converter.phrase_array << "prok"
     converter.convert_to_roman.should == "V"
    end

    it "converts pish to X" do
      converter.phrase_array << "pish"
      converter.convert_to_roman.should == "X"
    end

    it "converts tegj to L" do
      converter.phrase_array << "tegj"
      converter.convert_to_roman.should == "L"
    end
end

  context "#calculate_space_number" do
    it "converts I to 1" do
      converter.space_roman += "I"
      converter.calculate_space_number.should == 1
    end

    it "converts IV to 4" do
      converter.space_roman += "IV"
      converter.calculate_space_number.should == 4
    end

    it "converts IX to 9" do
      converter.space_roman += "IX"
      converter.calculate_space_number.should == 9
    end

    it "converts LIX to 59" do
      converter.space_roman += "LIX"
      converter.calculate_space_number.should == 59
    end
  end

  context "#multiply_mineral" do
    def converting
      converter.prepare_phrase
      converter.grab_mineral
      converter.convert_to_roman
      converter.calculate_space_number
      converter.multiply_mineral
    end

    it "muliplies by 17 for Silver" do
      converter.phrase << "glob glob silver"
      converting.should == 34
    end

    it "multiplies by 14450 for gold" do
      converter.phrase << "glob prok gold"
      converting.should == 57800
    end

    it "multiplies by 195.5 for Iron" do
      converter.phrase << "pish pish iron"
      converting.should == 3910
    end
  end

  context "#return_statement" do
    def converting
      converter.prepare_phrase
      converter.grab_mineral
      converter.convert_to_roman
      converter.calculate_space_number
      converter.multiply_mineral
      converter.return_statement
    end

    it "converts pish tegj glob glob to 42" do
      converter.phrase << "pish tegj glob glob"
      converting.should == "pish tegj glob glob is 42"
    end

    it "converts glob prok Silver to 68 Credits" do
      converter.phrase << "glob prok silver"
      converting.should == "glob prok silver is 68 Credits"
    end

    it "converts glob prok Gold to 57800 Credits" do
      converter.phrase << "glob prok gold"
      converting.should == "glob prok gold is 57800 Credits"
    end

    it "converts glob prok Iron to 782 Credits" do
      converter.phrase << "glob prok iron"
      converting.should == "glob prok iron is 782 Credits"
    end
  end
end
