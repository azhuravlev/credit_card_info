# frozen_string_literal: true

require_relative "lib/credit_card_info/version"

Gem::Specification.new do |s|
  s.name          = "credit_card_info"
  s.version       = CreditCardInfo::VERSION
  s.authors     = ["Alexey Zhuravlev"]
  s.email       = ["alexey.g.zhuravlev@gmail.com"]
  s.summary     = "Find credit card info by BIN(IIN)"
  s.description = <<-DESC
    Fetch credit card info from www.bincodes.com with configurable fallback to https://github.com/hugolantaume/credit_card_bins data.
    Also provides caching results for decreasing bincodesAPI request count/
  DESC

  s.license = "MIT"
  s.homepage = "https://github.com/azhuravlev/credit_card_info"

  s.metadata["allowed_push_host"] = "https://rubygems.org"

  s.required_ruby_version = ">= 2.7"

  s.add_dependency "credit_card_bins", "~> 0.0.1"
  s.add_dependency "dry-configurable", ">= 0.13"

  s.files         = `find *`.split("\n").uniq.sort.reject(&:empty?)
  s.test_files    = `find spec/*`.split("\n")
  s.executables   = []
  s.require_paths = ["lib"]
end
