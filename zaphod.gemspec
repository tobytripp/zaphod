$:.push File.expand_path( "../lib", __FILE__ )
require "zaphod/version"

Gem::Specification.new do |spec|
  spec.name = "zaphod"
  spec.version = Zaphod::VERSION

  spec.authors  = ["Toby Tripp"]
  spec.email    = %q{toby.tripp+gems@gmail.com}
  spec.homepage = %q{http://github.com/tobytripp/zaphod}

  spec.summary = %q{Catch untested commits and report them.}
  spec.description = %q{}

  spec.files            = `git ls-files`.split("\n")
  spec.executables      = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  spec.require_paths    = ["lib"]

  spec.extra_rdoc_files = %w[README.org]
  spec.rdoc_options     = ["--charset=UTF-8"]

  spec.add_dependency "git",       "~> 1.2.6"
  spec.add_dependency "simplecov", "~> 0.8"

  spec.add_development_dependency "rake",  "~> 10.1"
  spec.add_development_dependency "rr",    "~> 1.1"
  spec.add_development_dependency "rspec", "~> 2.14"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "guard", "~> 2.4"
  spec.add_development_dependency "guard-rspec", "~> 4.2"
  spec.add_development_dependency "guard-bundler"
  spec.add_development_dependency "guard-shell"
  spec.add_development_dependency "rb-fsevent"
  spec.add_development_dependency 'rb-readline'
end
