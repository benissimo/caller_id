require 'timecop'
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir     = 'spec/cassettes'

  c.hook_into                  :webmock
end

RSpec.configure do |config|
  config.extend VCR::RSpec::Macros
end
