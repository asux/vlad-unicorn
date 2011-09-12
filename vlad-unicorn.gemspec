# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name        = "vlad-unicorn"
  s.version     = "2.0.1"
  s.authors     = ["Kevin R. Bullock", "Oleksandr Ulianytskyi"]
  s.email       = ["kbullock@ringworld.org", "a.ulyanitsky@gmail.com"]
  s.homepage    = "http://bitbucket.org/krbullock/vlad-unicorn/"
  s.summary     = %q{Unicorn app server support for Vlad}
  s.description = %q{Unicorn app server support for Vlad. Adds support for vlad:start_app
  and

  vlad:stop_app using Unicorn[http://unicorn.bogomips.org/].}

  s.rubyforge_project = "vlad-unicorn"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.extra_rdoc_files = ["README.rdoc", "History.rdoc", "Manifest.txt", "docs/rails-configuration.rdoc"]

  s.add_runtime_dependency "vlad", "~> 2.0"
end
