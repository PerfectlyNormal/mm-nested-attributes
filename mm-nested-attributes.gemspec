# -*- encoding: utf-8 -*-
require File.expand_path('../lib/mm-nested-attributes/version', __FILE__)

Gem::Specification.new do |s|
  s.name = %q{mm-nested-attributes}
  s.authors = ["Toni Tuominen"]
  s.email = %q{toni@piranhadigital.fi}
  s.homepage = %q{http://github.com/tjtuom/mm-nested-attributes}

  s.version = MmNestedAttributes::VERSION
  s.date = %q{2010-07-10}
  s.summary = %q{A port of ActiveRecord's nested attributes functionality for MongoMapper}
  s.description = %q{A port of ActiveRecord's nested attributes functionality for MongoMapper.}

  s.files         = `git ls-files`.split($\)
  s.executables   = s.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]

  s.extra_rdoc_files = ["History.txt", "README.md"]
  s.rdoc_options = ["--main", "README.txt"]

  s.add_runtime_dependency(%q<mongo_mapper>, [">= 0.11.1"])
end
