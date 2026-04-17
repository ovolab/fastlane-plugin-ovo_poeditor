require 'spec_helper'

describe Fastlane::Helper::OvoPoeditorHelper do
  describe '.normalize_newlines' do
    it 'replaces \\n in values with \n' do
      input = '"STORE MODE:\\nCOME AND VISIT US!" = "MAĞAZA MODU:\\nGELİP BİZİ ZİYARET EDİN!";'
      expected = '"STORE MODE:\\nCOME AND VISIT US!" = "MAĞAZA MODU:\nGELİP BİZİ ZİYARET EDİN!";'
      expect(described_class.normalize_newlines(input)).to eq(expected)
    end

    it 'leaves keys unchanged with double \n' do
      input = '"KEY\\nFOO" = "value\\nhere";'
      result = described_class.normalize_newlines(input)
      expect(result).to include('"KEY\\nFOO"')
      expect(result).to include('"value\nhere"')
    end

    it 'leaves keys unchanged with single \n' do
      input = '"KEY\nFOO" = "value\\nhere";'
      result = described_class.normalize_newlines(input)
      expect(result).to include('"KEY\nFOO"')
      expect(result).to include('"value\nhere"')
    end

    it 'handles multiple \\n in a value' do
      input = '"KEY" = "line1\\nline2\\nline3";'
      expected = '"KEY" = "line1\nline2\nline3";'
      expect(described_class.normalize_newlines(input)).to eq(expected)
    end

    it 'does not modify values without \\n' do
      input = '"KEY" = "simple value";'
      expect(described_class.normalize_newlines(input)).to eq(input)
    end

    it 'processes a multi-line strings file correctly' do
      input = <<~STRINGS
        "KEY_1" = "value\\none";
        "KEY_2" = "normal value";
        "KEY_3\\nFOO" = "value\\ntwo";
      STRINGS
      result = described_class.normalize_newlines(input)
      expect(result).to include('"value\none"')
      expect(result).to include('"normal value"')
      expect(result).to include('"KEY_3\\nFOO"')
      expect(result).to include('"value\ntwo"')
    end
  end
end
