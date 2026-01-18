# spec/support/pony.rb
# frozen_string_literal: true

require 'pony'

RSpec.configure do |config|
  config.before(:each) do
    allow(Pony).to receive(:mail).and_return(true)
  end
end
