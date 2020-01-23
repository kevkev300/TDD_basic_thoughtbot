# Use TDD principles to build out name functionality for a Person.
# Here are the requirements:
# - X Add a method to return the full name as a string. A full name includes
#   first, middle, and last name. If the middle name is missing, there shouldn't
#   have extra spaces.
# - X Add a method to return a full name with a middle initial. If the middle name
#   is missing, there shouldn't be extra spaces or a period.
# - Add a method to return all initials. If the middle name is missing, the
#   initials should only have two characters.
#
# We've already sketched out the spec descriptions for the #full_name. Try
# building the specs for that method, watch them fail, then write the code to
# make them pass. Then move on to the other two methods, but this time you'll
# create the descriptions to match the requirements above.

class Person
  def initialize(first_name:, middle_name: nil, last_name:)
    @first_name = first_name
    @middle_name = middle_name
    @last_name = last_name
  end

  def full_name
    middle = "#{@middle_name} "
    "#{@first_name} #{middle if @middle_name}#{@last_name}"
  end

  def full_name_with_middle_initial
    middle = @middle_name ? "#{@middle_name.split("")[0].upcase}. " : ""
    "#{@first_name} #{middle}#{@last_name}"
  end

  def initials
    middle = @middle_name ? "#{@middle_name.split("")[0].upcase}. " : ""
    "#{@first_name.split("")[0]}. #{middle}#{@last_name.split("")[0]}."
  end
  # implement your behavior here
end

RSpec.describe Person do
  describe "#full_name" do
    it "concatenates first name, middle name, and last name with spaces" do
      person = Person.new(first_name: "Kevin", middle_name: "Dennis", last_name: "Liebholz")
      expect(person.full_name).to eq("Kevin Dennis Liebholz")
    end

    it "does not add extra spaces if middle name is missing" do
      person = Person.new(first_name: "Kevin", last_name: "Liebholz")
      expect(person.full_name).to eq("Kevin Liebholz")
    end
  end

  describe "#full_name_with_middle_initial" do
    it "concatinates first name, middle name initial and last name with spaces" do
      person = Person.new(first_name: "Kevin", middle_name: "Dennis", last_name: "Liebholz")
      expect(person.full_name_with_middle_initial).to eq("Kevin D. Liebholz")
    end

    it "does not add extra space if middle name is missing." do
      person = Person.new(first_name: "Kevin", last_name: "Liebholz")
      expect(person.full_name_with_middle_initial).to eq("Kevin Liebholz")
    end
  end

  describe "#initials" do
    it "returns initials of first name, middle name and last name with spaces" do
      person = Person.new(first_name: "Kevin", middle_name: "Dennis", last_name: "Liebholz")
      expect(person.initials).to eq("K. D. L.")
    end

    it "does not add extra space if middle name is missing" do
      person = Person.new(first_name: "Kevin", last_name: "Liebholz")
      expect(person.initials).to eq("K. L.")
    end
  end

end
