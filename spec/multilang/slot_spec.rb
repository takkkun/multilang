require 'spec_helper'
require 'multilang/slot'

describe Multilang::Slot, '#register' do
  before do
    @slot = described_class.new
  end

  it 'registers the object to the slot' do
    object = Object.new
    @slot.register(:en, object)
    @slot.should be_exists('English')
    @slot['English'].should == object
  end
end

describe Multilang::Slot, '#[]' do
  before do
    @slot = described_class.new
  end

  it 'returns registered object' do
    object = Object.new
    @slot.register(:en, object)
    @slot['English'].should == object
  end

  it 'calls the block once if gives a block at construction' do
    count = 0
    @slot.register(:en, Object.new) { count += 1 }
    @slot['English']
    count.should == 1
    @slot['English']
    count.should == 1
  end

  it 'raises ArgumentError if the language specifier does not register to the slot' do
    lambda { @slot[:en] }.should raise_error(ArgumentError, ':en does not register')
  end
end

describe Multilang::Slot::Access, '#slot' do
  before do
    @slot = slot_stub
    @class = Class.new
    @class.extend(described_class)
    @class.instance_variable_set(Multilang::SLOT_KEY, @slot)
  end

  it 'returns the value of instance variable named with Multilang::SLOT_KEY' do
    @class.slot.should == @slot
  end
end

describe Multilang::Slot::Access, '#[]' do
  before do
    @slot = slot_stub
    @class = Class.new
    @class.extend(described_class)
    @class.instance_variable_set(Multilang::SLOT_KEY, @slot)
  end

  it 'calls #[] of the slot with the language specifier' do
    @class.slot.should_receive(:[]).with('English')
    @class['English']
  end

  it 'returns the return value from #[] of the slot' do
    @class['English'].should == 'item for English'
  end
end
