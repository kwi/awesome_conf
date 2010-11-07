Gem::Specification.new do |s|
  s.name = "awesome_conf"
  s.version = "0.1"
  s.author = "Guillaume Luccisano"
  s.email = "guillaume.luccisano@gmail.com"
  s.homepage = "http://github.com/kwi/awesome_conf"
  s.summary = "The easiest and the cleanest way to add some configuration variables to any ruby project."
  s.description = "The easiest and the cleanest way to add some configuration variables to any ruby project."

  s.files = Dir["{lib,spec}/**/*", "[A-Z]*", "init.rb"]
  s.require_path = "lib"

  s.rubyforge_project = s.name
  s.required_rubygems_version = ">= 1.3.4"
end