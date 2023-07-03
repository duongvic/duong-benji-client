# -*- encoding: utf-8 -*-
$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'benji/client/version'

Gem::Specification.new do |s|
  s.name              = 'benji-client'
  s.version           = Benji::Client::VERSION
  s.summary           = 'A suite of reading metrics stored on ' \
                        'a Benji server.'
  s.authors           = ['KhanhCT']
  s.email             = ['khanhct@fpt.com.vn']
  s.homepage          = 'https://git.fptcompute.com.vn/khanhct/benji-client'
  s.license           = 'Apache-2.0'

  s.files             = %w(README.md) + Dir.glob('{lib/**/*}')
  s.require_paths     = ['lib']

  s.add_dependency 'faraday', '>= 0.9', '< 2.0.0'
end
