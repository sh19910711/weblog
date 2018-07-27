require 'spec_helper'

describe Note::Note do
  context '.new(example)' do
    before do
      @note = Note::Note.new(path: SPEC_ROOT + 'fixtures/example_note.json')
      allow(@note).to receive(:created_at).and_return(Date.parse('2018/06/23'))
      @note.tags.push(Note::Tag.new(name: 'hello'))
      @note.fetch
    end

    context '.name' do
      subject { @note.name }
      it { should eq 'AWS/環境構築/Python' }
    end

    context '.paragraphs' do
      subject { @note.paragraphs.first }
      it { should be_a Note::Paragraph }
    end

    context '.date' do
      subject { @note.date }
      it { should eq '2018/06/23' }
    end

    context '.tags' do
      subject { @note.tags.first.name }
      it { should eq 'hello' }
    end
  end
end
