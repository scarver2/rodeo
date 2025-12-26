# frozen_string_literal: true

# Guardfile
# More info at https://github.com/guard/guard#readme

def extensions
  {
    coffee: :js,
    css: :css,
    gif: :gif,
    html: :html,
    jpeg: :jpeg,
    jpg: :jpg,
    js: :js,
    png: :png,
    sass: :css,
    scss: :css,
    svg: :svg
  }
end

# File types LiveReload may optimize refresh for
def compiled_extensions
  extensions.values.uniq
end

# Rubocop local configuration, overrides .rubocop.yml
# --auto-correct
# --format progress --format offenses
# --format pacman
# --format quiet
# --parallel

def rubocop_args
  [
    '-A',
    '--format progress',
    '--parallel'
  ].join(' ')
end

# View template extensions
def view_extensions
  %w[erb haml slim]
end

guard :bundler do
  require 'guard/bundler'
  require 'guard/bundler/verify'
  helper = Guard::Bundler::Verify.new

  # Watch Gemfile and gemspecs
  files = ['Gemfile']
  files += Dir['*.gemspec'] if files.any? { |f| helper.uses_gemspec?(f) }

  # Assume files are symlinked from somewhere
  files.each { |file| watch(helper.real_path(file)) }
end

guard :rspec, cmd: 'bundle exec rspec' do
  ENV['COVERAGE'] = 'true'
  require 'guard/rspec/dsl'
  dsl = Guard::RSpec::Dsl.new(self)

  # Feel free to open issues for suggestions and improvements

  # RSpec files
  rspec = dsl.rspec
  watch(rspec.spec_helper) { rspec.spec_dir }
  watch(rspec.spec_support) { rspec.spec_dir }
  watch(rspec.spec_files)

  # Ruby files
  ruby = dsl.ruby
  dsl.watch_spec_files_for(ruby.lib_files)

  # Rails files
  rails = dsl.rails(view_extensions: %w[erb haml slim])
  dsl.watch_spec_files_for(rails.app_files)
  dsl.watch_spec_files_for(rails.views)

  watch(rails.controllers) do |m|
    [
      rspec.spec.call("routing/#{m[1]}_routing"),
      rspec.spec.call("controllers/#{m[1]}_controller"),
      rspec.spec.call("acceptance/#{m[1]}")
    ]
  end

  # Rails config changes
  watch(rails.spec_helper)     { rspec.spec_dir }
  watch(rails.routes)          { "#{rspec.spec_dir}/routing" }
  watch(rails.app_controller)  { "#{rspec.spec_dir}/controllers" }

  # Capybara features specs
  watch(rails.view_dirs)     { |m| rspec.spec.call("features/#{m[1]}") }
  watch(rails.layouts)       { |m| rspec.spec.call("features/#{m[1]}") }

  # Turnip features and steps
  watch(%r{^spec/acceptance/(.+)\.feature$})
  watch(%r{^spec/acceptance/steps/(.+)_steps\.rb$}) do |m|
    Dir[File.join("**/#{m[1]}.feature")][0] || 'spec/acceptance'
  end
end

guard :rubocop, all_on_start: true, cli: rubocop_args do
  watch(/.+\.rb|ru$/)
  watch(%r{(?:.+/)?\.rubocop(?:_todo)?\.yml$}) { |m| File.dirname(m[0]) }
end

guard 'livereload', notify: true do
  watch(%r{^views/.+\.(erb|haml|slim)$})
  watch(%r{^public/.+\.(css|js|png|gif|jpe?g|svg)$})
  watch(%r{^app/.+\.rb$})
  watch('app.rb')
  watch('config.ru')
end
