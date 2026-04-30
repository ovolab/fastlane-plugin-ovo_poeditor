require 'spec_helper'

describe Fastlane::Helper::OvoPoeditorHelper do
  describe '.fetch_export_url' do
    let(:http_double) { instance_double(Net::HTTP) }
    let(:response_double) do
      double('response').tap do |r|
        allow(r).to receive(:is_a?).with(Net::HTTPSuccess).and_return(true)
        allow(r).to receive(:body).and_return('{"result":{"url":"https://example.com/file.strings"}}')
      end
    end

    before do
      allow(Net::HTTP).to receive(:start).and_yield(http_double)
      allow(http_double).to receive(:request).and_return(response_double)
    end

    context 'when fallback_languages maps the current language' do
      it 'includes fallback_language in the form data sent to the API' do
        captured_form_data = nil
        allow_any_instance_of(Net::HTTP::Post).to receive(:set_form_data) do |_req, data|
          captured_form_data = data
        end

        described_class.fetch_export_url(
          api_token: 'token',
          project_id: '123',
          language: 'it',
          file_format: 'apple_strings',
          unquoted_strings: 0,
          fallback_languages: { 'it' => 'en' }
        )

        expect(captured_form_data['fallback_language']).to eq('en')
      end
    end

    context 'when fallback_languages does not include the current language' do
      it 'does not include fallback_language in the form data' do
        captured_form_data = nil
        allow_any_instance_of(Net::HTTP::Post).to receive(:set_form_data) do |_req, data|
          captured_form_data = data
        end

        described_class.fetch_export_url(
          api_token: 'token',
          project_id: '123',
          language: 'de',
          file_format: 'apple_strings',
          unquoted_strings: 0,
          fallback_languages: { 'it' => 'en' }
        )

        expect(captured_form_data).not_to have_key('fallback_language')
      end
    end

    context 'when fallback_languages is nil' do
      it 'does not include fallback_language in the form data' do
        captured_form_data = nil
        allow_any_instance_of(Net::HTTP::Post).to receive(:set_form_data) do |_req, data|
          captured_form_data = data
        end

        described_class.fetch_export_url(
          api_token: 'token',
          project_id: '123',
          language: 'it',
          file_format: 'apple_strings',
          unquoted_strings: 0,
          fallback_languages: nil
        )

        expect(captured_form_data).not_to have_key('fallback_language')
      end
    end

    context 'when the language maps to an empty fallback value' do
      it 'does not include fallback_language in the form data' do
        captured_form_data = nil
        allow_any_instance_of(Net::HTTP::Post).to receive(:set_form_data) do |_req, data|
          captured_form_data = data
        end

        described_class.fetch_export_url(
          api_token: 'token',
          project_id: '123',
          language: 'it',
          file_format: 'apple_strings',
          unquoted_strings: 0,
          fallback_languages: { 'it' => '' }
        )

        expect(captured_form_data).not_to have_key('fallback_language')
      end
    end
  end

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
