require 'spec_helper'

describe TimeScales do
  it 'has a version number' do
    expect(TimeScales::VERSION).not_to be nil
  end

  describe '#[]' do
    it 'rejects invocation with no arguments' do
      expect do
        TimeScales[]
      end.to raise_exception(ArgumentError)
    end

    it 'rejects invocation with first argument not a symbol, unit, part, or hash' do
      expect do
        TimeScales[1]
      end.to raise_exception(ArgumentError)
    end

    it 'rejects invocation with hash as first argument and with additional arguments' do
      expect do
        TimeScales[{ :year => 1 }, :month]
      end.to raise_exception(ArgumentError)
    end

    it 'returns a corresponding frame type, given 1 or more part/unit keys' do
      expected = TimeScales::Frame.type_for(:day, :hour)

      expect(TimeScales[:day, :hour]).to eq(expected)
      expect(TimeScales[:day, :hour_of_day]).to eq(expected)
      expect(TimeScales[TimeScales::Units::Day, :hour]).to eq(expected)
      expect(TimeScales[TimeScales::Parts::DayOfMonth, :hour]).to eq(expected)
    end

    it 'returns a corresponding frame instance, given a key/value hash' do
      actual = TimeScales[:day => 20, :hour => 16]
      expected = TimeScales::Frame[:day => 20, :hour => 16]
      expect(actual).to eq(expected)
    end
  end
end
