describe Fastlane::Actions::OvoPoeditorAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The ovo_poeditor plugin is working!")

      Fastlane::Actions::OvoPoeditorAction.run(nil)
    end
  end
end
