require './config/environment'

use Rack::Static, urls: ['/stylesheets'], root: 'public' # Rack fix allows seeing the css folder.

#if ActiveRecord::Migrator.needs_migration?
#  raise 'Migrations are pending. Run `rake db:migrate` to resolve the issue.'
#end

if defined?(ActiveRecord::Migrator) && ActiveRecord::Migrator.needs_migration?
  raise 'Migrations are pending run `rake db:migrate` to resolve the issue.'
end


use Rack::MethodOverride

use UsersController
run ApplicationController