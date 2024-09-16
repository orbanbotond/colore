# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Colore::Converter do
  let(:storage_dir) { tmp_storage_dir }
  let(:doc_key) { Colore::DocKey.new('app', '12345') }
  let(:version) { 'v001' }
  let(:filename) { 'arglebargle.docx' }
  let(:action) { 'pdf' }
  let(:new_filename) { 'arglebargle.txt' }
  let(:converter) { described_class.new }
  let(:document) { Colore::Document.load storage_dir, doc_key }

  before do
    setup_storage
    allow(Colore::C_.config).to receive(:storage_directory) { tmp_storage_dir }
    stubbed_converter = instance_double(Heathen::Converter, convert: "The quick brown fox")
    allow(Heathen::Converter).to receive(:new).and_return(stubbed_converter)
  end

  after do
    delete_storage
  end

  describe '#convert' do
    it 'runs' do
      expect(converter.convert(doc_key, version, filename, action)).to eq new_filename
      content_type, content = document.get_file version, new_filename
      expect(content_type).to eq 'text/plain; charset=us-ascii'
      expect(content.to_s).to eq 'The quick brown fox'
    end
  end
end
