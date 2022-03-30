source 'https://rubygems.org'
ruby "2.5.5"

gem 'rails',                   '5.2.3'
gem 'railties',                '5.2.3'
gem 'bcrypt',                  '3.1.7'
gem 'faker',                   '1.4.2'
gem 'carrierwave',             '1.2.1'             
gem 'mini_magick',             '3.8.0'
gem 'fog',                     '1.36.0'
gem 'will_paginate',           '3.1.6'
gem 'bootstrap-will_paginate', '0.0.10'
gem 'bootstrap-sass',          '3.4.1'
gem 'puma',                    '~> 4.3'
gem "font-awesome-rails",      '4.7.0.5'
gem 'sass-rails',              '5.0.7'
gem 'uglifier',                '2.5.3'
gem 'coffee-rails',            '~> 4.2'
gem 'jquery-rails',            '4.3.1'
gem 'jquery-ui-rails',         '5.0.5'
gem 'turbolinks',              '~> 5'
gem 'jbuilder',                '2.7.0'
gem 'sdoc',                    '0.4.0', group: :doc
gem 'fullcalendar-rails',      '3.4.0.0'
gem 'momentjs-rails',          '2.11.1'
gem 'prawn',                   '2.2.2'
gem 'prawn-table',             '0.2.2'
gem 'figaro',                  '1.1.1'
gem 'strip_attributes',        '1.8.0'
gem 'web-console',             '3.5.1', group: :development #as of rails 5.0, it's not a good idea to have this in :test

group :development, :test do
  gem 'sqlite3',     '1.3.9'
  gem 'byebug',      '3.4.0'
  gem 'spring'
end

group :test do
  gem 'minitest-reporters', '1.0.5'
  gem 'mini_backtrace',     '0.1.3'
  gem 'guard-minitest',     '2.3.1'
  gem 'rails-controller-testing' #assert_template and assigns extracted to this gem, used to be bundled with rails
end

group :production do
  gem 'pg',             '~>0.18'
  gem 'rails_12factor', '0.0.2'
end
