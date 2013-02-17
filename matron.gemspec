$:.push File.expand_path( "../lib", __FILE__ )
require "matron/version"

Gem::Specification.new do |spec|
  spec.name = "matron"
  spec.version = Matron::VERSION

  spec.authors = ["Toby Tripp"]
  spec.email    = %q{toby.tripp+gems@gmail.com}
  spec.homepage = %q{http://github.com/tobytripp/matron}

  spec.summary = %q{Catch untested commits.}
  spec.description = %q{}

  spec.files            = `git ls-files`.split("\n")
  spec.executables      = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  spec.require_paths    = ["lib"]

  spec.extra_rdoc_files = %w[README.rdoc]
  spec.rdoc_options     = ["--charset=UTF-8"]

  spec.rubyforge_project = "matron"

  spec.add_dependency "grit", "~> 2.5.0"

  spec.add_development_dependency "rake",  "~> 10.0.3"
  spec.add_development_dependency "rspec", "~> 2.12.0"
end
