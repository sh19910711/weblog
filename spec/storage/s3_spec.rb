require 'spec_helper'

describe Storage::S3, e2e: true do
  context '.new' do
    let(:storage) { Storage::S3.new }
    context '.read_object' do
      let(:url) { 's3://hiroyuki.sano.ninja/test/example.json' }
      subject { storage.read_object(url) }
      it { should include "AWS/環境構築/Python" }
    end
  end
end
