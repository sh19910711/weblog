require 'spec_helper'

describe Note::Tag do
  context '.new' do
    before { @tag = Note::Tag.new(name: 'tag-name') }
    context '.name' do
      subject { @tag.name }
      it { should eq 'tag-name' }
    end
  end
end
