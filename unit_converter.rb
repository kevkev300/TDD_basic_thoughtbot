# to run tests use 'rspec unit_coverter.rb' in command line
# UnitConverter.new(2, cups, liter).convert to eq 0.473 liters

UnitMissmatchError = Class.new(StandardError)

Quantity = Struct.new(:amount, :unit)

class UnitConverter
  def initialize(initial_quantity, to_unit)
    @initial_quantity = initial_quantity
    @to_unit = to_unit
  end

  def convert
    Quantity.new(
      @initial_quantity.amount * conversion_factor(from: @initial_quantity.unit, to: @to_unit),
      @to_unit
    )
  end

  private

  CONVERSION_FACTORS = {
    liter: {
      liter: 1,
      cup: 4.226775,
      pint: 2.11338
    },

    gram: {
      gram: 1,
      kilogram: 1000
    }
  }

  def conversion_factor(from:, to:)
    dimension = common_dimension(from, to)
    if !dimension.nil?
      CONVERSION_FACTORS[dimension][to] / CONVERSION_FACTORS[dimension][from]
    else
      raise(UnitMissmatchError, "Can't convert between #{from} and #{to}")
    end
  end

  def common_dimension(from, to)
    CONVERSION_FACTORS.keys.find do |cannonical_unit|
      CONVERSION_FACTORS[cannonical_unit].keys.include?(from) &&
        CONVERSION_FACTORS[cannonical_unit].keys.include?(to)
    end
  end
end

# --- tests ---

describe UnitConverter do
  describe "#convert" do
    it "converts between two different units of the same dimension" do
      initial_quantity = Quantity.new(2, :cup)
      converter = UnitConverter.new(initial_quantity, :liter)

      result = converter.convert

      expect(result.amount).to be_within(0.1).of(0.473)
      expect(result.unit).to eq(:liter)
    end

    it "raises an UnitMissmatchError if units are of differing dimensions" do
      initial_quantity = Quantity.new(2, :cup)
      converter = UnitConverter.new(initial_quantity, :gramm)
      expect { converter.convert }.to raise_error(UnitMissmatchError)
    end

    it "can convert between quantities of the same unit" do
      initial_quantity = Quantity.new(2, :cup)
      converter = UnitConverter.new(initial_quantity, :cup)

      result = converter.convert

      expect(result.amount).to be_within(0.001).of(2)
      expect(result.unit).to eq(:cup)
    end
  end
end
