# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_blogger_session',
  :secret      => '7a313fc2b800a18b49dc29c1413ed555e2a153aa79eb2834c1718ab8ec5efd8ddb3b08217ddf0f0e2b30119f8ebfb661bbe7fcf5d6b8f44961cf6b8e4d3a082d'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
