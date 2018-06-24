require 'spec_helper'

describe Note::Note do
  context '.new(example)' do
    before do
      @note = Note::Note.new(SPEC_ROOT + 'fixtures/example_note.json')
    end

    context '.name' do
      subject { @note.name }
      it { should eq 'AWS/環境構築/Python' }
    end
  end
end
