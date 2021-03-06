# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
require 'zaphod'
Zaphod.setup do |config|
  config.on_failure do
    puts "Untested CHANGES! You damned hypocrite!"
    exit( -1 ) unless RSpec.configuration.filter.keys.include?( :line_numbers )
  end
end

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.mock_with :rr

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'
end
