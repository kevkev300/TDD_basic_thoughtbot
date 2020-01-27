require_relative "quantity"

class UnitConverter
  def initialize(initial_quantity, to_unit)
    @initial_quantity = initial_quantity
    @to_unit = to_unit
  end

  def convert
    Quantity.new(
      amount: @initial_quantity.amount * conversion_ratio,
      to: @to_unit)
  end

  private

  attr_reader :conversion_database, :initial_quantity, :to_unit

  def conversion_ratio(from:, to:)
    conversion_database.conversion_ratio(
      from: initial_quantity.unit,
      to: to_unit
    )
  end
end
