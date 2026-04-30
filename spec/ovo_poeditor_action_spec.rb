require 'spec_helper'

describe Fastlane::Actions::OvoPoeditorStringsAction do
  it 'is supported on all platforms' do
    expect(described_class.is_supported?(:ios)).to be true
    expect(described_class.is_supported?(:android)).to be true
  end
end
