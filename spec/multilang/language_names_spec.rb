require 'multilang/language_names'

describe Multilang::LanguageNames, '.#[]' do
  it 'returns normalized language name if the language specifier is string' do
    described_class['english'].should == 'English'
  end

  it 'returns language name if the language specifier is symbol' do
    described_class[:en ].should == 'English'
    described_class[:eng].should == 'English'
  end

  it 'raises TypeError if the language specifier is not string and symbol' do
    lambda { described_class[1] }.should raise_error(TypeError, "can't convert Fixnum into String or Symbol")
  end

  it 'raises ArgumentError if the language specifier does not exist' do
    lambda { described_class['unknown'] }.should raise_error(ArgumentError, '"unknown" language specifier does not defined')
  end
end
