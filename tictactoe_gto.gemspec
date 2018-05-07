
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "tictactoe_gto/version"

Gem::Specification.new do |spec|
  spec.name          = "tictactoe_gto"
  spec.version       = TictactoeGto::VERSION
  spec.authors       = ["Jaimelr"]
  spec.email         = ["j.loyolarangel@gmail.com"]

  spec.summary       = %q{A modifiy version of the classic TicTacToe game}
  spec.description   = %q{This is an improved version of the classic game TicTacToe with new features such as customizable IDs and the posibility to play on boards of any size (bigger than 2)}
  spec.homepage      = "https://github.com/jaimelr/tictactoe_gto"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
end
