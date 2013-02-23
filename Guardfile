# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard :bundler do
  watch 'matron.gemspec'
  watch 'Gemfile'
end

guard 'rspec' do
  watch( %r{^spec/.+_spec\.rb$} )
  watch( %r{^lib/(.+)\.rb$} )   { |m| "spec/#{m[1]}_spec.rb" }
  watch( 'spec/spec_helper.rb' )  { "spec" }
end

guard 'shell' do
  watch( %r{^lib/.+\.rb$} ) { `ctags -R -e lib` }
end