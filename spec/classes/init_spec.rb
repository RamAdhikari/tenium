require 'spec_helper'
describe 'tanium' do

  context 'with defaults for all parameters' do
    it { should contain_class('tanium') }
  end
end
