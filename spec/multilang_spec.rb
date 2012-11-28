require 'spec_helper'
require 'multilang'

describe Multilang, '.#register' do
  before do
    define_const Class,  'SampleClass::English'
    define_const Module, 'SampleModule::English'
  end

  after do
    remove_const 'SampleClass::English'
    remove_const 'SampleModule::English'
  end

  it 'extends parent class (parent class of Foo::Bar::Baz is Foo::Bar)' do
    described_class.register SampleClass::English
    SampleClass.should be_respond_to(:slot)
    SampleClass.should be_respond_to(:[])
  end

  it 'extends parent module' do
    described_class.register SampleModule::English
    SampleModule.should be_respond_to(:slot)
    SampleModule.should be_respond_to(:[])
  end

  it 'registers to the slot' do
    described_class.register SampleClass::English
    SampleClass.slot.should be_exists('English')
  end

  it 'raises TypeError if gives non-module' do
    lambda { described_class.register 1 }.should raise_error(TypeError, "can't convert Fixnum into Module")
    lambda { described_class.register 'English' }.should raise_error(TypeError, "can't convert String into Module")
    lambda { described_class.register SampleClass::English }.should_not raise_error(TypeError)
    lambda { described_class.register SampleModule::English }.should_not raise_error(TypeError)
  end

  it 'raises ArgumentError if gives anonymous class' do
    lambda { described_class.register Class.new }.should raise_error(ArgumentError, "anonymous class can't register")
    lambda { described_class.register SampleClass::English }.should_not raise_error(ArgumentError)
  end

  it 'raises ArgumentError if gives anonymous module' do
    lambda { described_class.register Module.new }.should raise_error(ArgumentError, "anonymous module can't register")
    lambda { described_class.register SampleModule::English }.should_not raise_error(ArgumentError)
  end

  it 'raises ArgumentError if gives top-level class' do
    lambda { described_class.register SampleClass }.should raise_error(ArgumentError, "can't permit top-level class")
  end

  it 'raises ArgumentError if gives top-level module' do
    lambda { described_class.register SampleModule }.should raise_error(ArgumentError, "can't permit top-level module")
  end

  context 'with :as option' do
    before { define_const Class, 'SampleClass::E' }
    after  { remove_const        'SampleClass::E' }

    it 'registers to the slot with the value of :as option' do
      described_class.register SampleClass::E, :as => 'English'
      SampleClass.slot.should be_exists('English')
    end
  end

  context 'with :with option' do
    it 'calls Kernel#.require with the value of :with option at initialization' do
      Object.should_not be_const_defined(:ForTest)
      described_class.register SampleClass::English, :with => 'for_test'
      SampleClass['English']
      Object.should be_const_defined(:ForTest)
    end

    context 'with a block' do
      it 'considers both the value of :with option and the block' do
        Object.should_not be_const_defined(:ForTest2)
        passed = false

        described_class.register SampleClass::English, :with => 'for_test2' do
          passed = true
        end

        SampleClass['English']
        Object.should be_const_defined(:ForTest2)
        passed.should be_true
      end
    end
  end
end

describe Multilang, ' including' do
  before do
    define_const Class, 'SampleClass::English'
  end

  after do
    remove_const 'SampleClass::English'
  end

  it "calls #{described_class}.#register" do
    described_class.should_receive(:register).with(SampleClass::English)
    mod = described_class
    SampleClass::English.class_eval { include mod }
  end
end
