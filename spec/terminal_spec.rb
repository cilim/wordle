RSpec.describe Terminal do
  describe '#put' do
    let(:content) { 'ignore_in_specs' }

    it 'outputs content to terminal' do
      expect(described_class.put(content)).to eq(nil)
    end

    it 'outputs content to terminal without new line' do
      expect(described_class.put(content, new_line: false)).to eq(nil)
    end
  end

  describe '#white_on_green' do
    it 'wraps content in terminal color codes' do
      expect(described_class.white_on_green('CONTENT')).to eq("\e[37;42;1mCONTENT\e[0m")
    end
  end

  describe '#white_on_yellow' do
    it 'wraps content in terminal color codes' do
      expect(described_class.white_on_yellow('CONTENT')).to eq("\e[37;43;1mCONTENT\e[0m")
    end
  end

  describe '#white_on_red' do
    it 'wraps content in terminal color codes' do
      expect(described_class.white_on_red('CONTENT')).to eq("\e[37;41;1mCONTENT\e[0m")
    end
  end

  describe '#white_on_black' do
    it 'wraps content in terminal color codes' do
      expect(described_class.white_on_black('CONTENT')).to eq("\e[37;40mCONTENT\e[0m")
    end
  end
end
