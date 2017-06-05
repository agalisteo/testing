#!/usr/bin/env bash
RUBY_VERSIONS=("2.1.1" "2.1.5" "2.1.6" "2.1.9" "2.2.2" "2.2.3" "2.2.5" "2.3.0" "2.3.1" "2.3.3" "2.3.4" "2.4.0" "2.4.1")

eval "$(rbenv init -)"

for ruby in "${RUBY_VERSIONS[@]}"; do
  rbenv install $ruby
  rbenv shell $ruby
  gem install bundler --no-ri --no-rdoc
done
