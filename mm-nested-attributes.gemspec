# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{mm-nested-attributes}
  s.authors = ["Toni Tuominen"]
  s.email = %q{toni@piranhadigital.fi}
  s.homepage = %q{http://github.com/tjtuom/mm-nested-attributes}

  s.version = "0.1.3"
  s.date = %q{2010-07-10}
  s.summary = %q{A port of ActiveRecord's nested attributes functionality for MongoMapper}
  s.description = %q{A port of ActiveRecord's nested attributes functionality for MongoMapper.}

  s.files         = `git ls-files`.split($\)
  s.executables   = s.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]

  s.extra_rdoc_files = ["History.txt", "README.txt", "version.txt"]
  s.rdoc_options = ["--main", "README.txt"]

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<mongo_mapper>, [">= 0.8.2"])
      s.add_development_dependency(%q<rspec>, [">= 2.8.0"])
    else
      s.add_dependency(%q<mongo_mapper>, [">= 0.8.2"])
      s.add_dependency(%q<rspec>, [">= 2.8.0"])
    end
  else
    s.add_dependency(%q<mongo_mapper>, [">= 0.8.2"])
    s.add_dependency(%q<rspec>, [">= 2.8.0"])
  end
end
