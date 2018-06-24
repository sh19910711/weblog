require 'spec_helper'

describe Note::Paragraph do
  context '.new(content)' do
    before do
      @note = Note::Note.new(path: SPEC_ROOT + 'fixtures/example_note.json')
      @paragraphs = @note.paragraphs
    end

    let(:p) { @paragraphs[1] }

    context '.text' do
      subject { p.text }
      it { should include '%sh' }
    end

    context '.results' do
      subject { p.results.first.data }
      it { should include 'ec2-user' }
    end

    context '.date_started' do
      subject { p.date_started }
      it { should eq p.content['dateStarted'] }
    end

    context '.date_finished' do
      subject { p.date_finished }
      it { should eq p.content['dateFinished'] }
    end

    context '.date_updated' do
      subject { p.date_updated }
      it { should eq p.content['dateUpdated'] }
    end

    context '.editor_mode' do
      subject { p.editor_mode }
      it { should eq p.content['config']['editorMode'] }
    end

    context '.id' do
      subject { p.id }
      it { should eq p.content['id'] }
    end
  end
end
