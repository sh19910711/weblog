require 'spec_helper'

describe Model::Note do
  before { Model::Note.delete_all }
  context '.create' do
    subject { Model::Note.create(note_id: 'hello').note_id }
    it { should eq 'hello' }
  end
end
