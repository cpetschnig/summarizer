# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{summarizer}
  s.version = "0.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Christoph Petschnig"]
  s.date = %q{2010-02-07}
  s.description = %q{Make sums and subtotals of your database tables}
  s.email = %q{info@purevirtual.de}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "features/step_definitions/summarizer_steps.rb",
     "features/summarizer.feature",
     "features/support/env.rb",
     "lib/summarizer.rb",
     "lib/summarizer/add_it_up.rb",
     "lib/summarizer/base.rb",
     "lib/summarizer/static.rb",
     "spec/database.yml",
     "spec/factories.rb",
     "spec/fixtures/bars.yml",
     "spec/models/bar.rb",
     "spec/models/foo.rb",
     "spec/spec.opts",
     "spec/spec_helper.rb",
     "spec/summarizer_spec.rb",
     "summarizer.gemspec"
  ]
  s.homepage = %q{http://github.com/ChristophPetschnig/summarizer}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Make sums and subtotals of your database tables}
  s.test_files = [
    "spec/models/foo.rb",
     "spec/models/bar.rb",
     "spec/spec_helper.rb",
     "spec/summarizer_spec.rb",
     "spec/factories.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 1.2.9"])
      s.add_development_dependency(%q<yard>, [">= 0"])
      s.add_development_dependency(%q<cucumber>, [">= 0"])
    else
      s.add_dependency(%q<rspec>, [">= 1.2.9"])
      s.add_dependency(%q<yard>, [">= 0"])
      s.add_dependency(%q<cucumber>, [">= 0"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 1.2.9"])
    s.add_dependency(%q<yard>, [">= 0"])
    s.add_dependency(%q<cucumber>, [">= 0"])
  end
end

