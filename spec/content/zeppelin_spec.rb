require 'spec_helper'

describe Content::Zeppelin::Reader do
  context '.new(example.json)' do
		let(:body) { File.read(SPEC_ROOT + 'fixtures/example_note.json') }
		let(:reader) { Content::Zeppelin::Reader.new(body) }

		context '.paragraphs' do
			subject { reader.paragraphs.first }
			it { should be_a Content::Zeppelin::Paragraph }
		end
  end
end
