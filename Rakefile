require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-syntax/tasks/puppet-syntax'
require 'puppet-lint/tasks/puppet-lint'

exclude_paths = [
  'spec/fixtures/**/*',
  "pkg/**/*",
  "vendor/**/*",
  "spec/**/*",
]

PuppetSyntax::RakeTask.new
PuppetSyntax.exclude_paths = exclude_paths
PuppetSyntax.fail_on_deprecation_notices = true

# Puppet-Lint 1.1.0
Rake::Task[:lint].clear
PuppetLint::RakeTask.new :lint do |config|

  # Pattern of files to ignore
  config.ignore_paths = exclude_paths

  # List of checks to disable
  config.disable_checks = [
      '80chars',
      '140chars',
      'documentation',
      'class_inherits_from_params_class',
      'arrow_on_right_operand_line',
      'autoloader_layout',
    ]

  # Should puppet-lint prefix it's output with the file being checked,
  # defaults to true
  config.with_filename = false

  # Should the task fail if there were any warnings, defaults to false
  config.fail_on_warnings = true

  # Format string for puppet-lint's output (see the puppet-lint help output
  # for details
  config.log_format = '%{path}:%{line}: [%{KIND}] (%{check}) %{message}'

  # Print out the context for the problem, defaults to false
  config.with_context = true

  # Enable automatic fixing of problems, defaults to false
  config.fix = false

  # Show ignored problems in the output, defaults to false
  config.show_ignored = true
end

task :metadata do
  sh "metadata-json-lint --no-strict-license metadata.json"
end

task :default => [:syntax, :lint, :metadata]
