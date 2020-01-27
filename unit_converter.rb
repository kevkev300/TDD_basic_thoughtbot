require 'rspec/autorun'

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
    cup: {
      liter: 0.473
    }
  }

  def conversion_factor(from:, to:)
    CONVERSION_FACTORS[from][to] ||
      raise(UnitMissmatchError, "Can't convert between #{from} to #{to}")
  end
end

# --- tests ---

describe UnitConverter do
  describe "#convert" do
    it "converts between two different units of the same dimension" do
      initial_quantity = Quantity.new(2, :cup)
      converter = UnitConverter.new(initial_quantity, :liter)

      result = converter.convert

      expect(result.amount).to eq(2 * 0.473)
      expect(result.unit).to eq(:liter)
    end

    it "raises an UnitMissmatchError if units are of differing dimensions" do
      initial_quantity = Quantity.new(2, :cup)
      converter = UnitConverter.new(initial_quantity, :gramm)
      expect { converter.convert }.to raise_error(UnitMissmatchError)
    end
  end
end
