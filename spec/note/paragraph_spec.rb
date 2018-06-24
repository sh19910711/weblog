require 'spec_helper'

describe Note::Paragraph do
  context '.new(content)' do
    before do
      @note = Note::Note.new(SPEC_ROOT + 'fixtures/example_note.json')
      @paragraphs = @note.paragraphs
    end

    context '.text' do
      subject { @paragraphs[0].text }
      it { should include '%sh' }
    end

    context '.results' do
      context 'with results' do
        subject { @paragraphs[1].results }
        it { should include 'ec2-user' }
      end

      context 'with no results' do
        subject { @paragraphs[0].results }
        it { should be_nil }
      end
    end
  end
end
