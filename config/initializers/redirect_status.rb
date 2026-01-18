# config/initializers/redirect.rb
# frozen_string_literal: true

# Common HTTP redirect status codes
# https://developer.mozilla.org/en-US/docs/Web/HTTP/Status#redirection_messages
module RedirectStatus
  PERMANENT              = 301 # “Moved Permanently” (cacheable)
  FOUND                  = 302 # common “temporary” redirect (may switch method)
  POST_TO_GET            = 303 # after POST, redirect to a GET (PRG pattern)
  TEMPORARY_PRESERVE_VERB = 307 # temporary, preserves method + body
  PERMANENT_PRESERVE_VERB = 308 # permanent, preserves method + body
end
