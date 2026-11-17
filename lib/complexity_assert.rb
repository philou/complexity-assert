require "complexity_assert/core"

# The test framework integrations are optional: only hook into the framework
# that is already loaded. Require 'complexity_assert/matchers' or
# 'complexity_assert/minitest' explicitly to force one of them.
require "complexity_assert/matchers" if defined?(::RSpec)
require "complexity_assert/minitest" if defined?(::Minitest)
