# These should be setup as environment variables or in the Rails credentials file

MANYCOMM_WEBSITE_DOMAIN = ENV['MANYCOMM_WEBSITE_DOMAIN'] || 'localhost:3000'
MANYCOMM_NOREPLY_EMAIL = ENV['MANYCOMM_NOREPLY_EMAIL'] || 'noreply@yourdomain.com'
MANYCOMM_NOTIFICATION_EMAIL = ENV['MANYCOMM_NOTIFICATION_EMAIL'] || 'noreply@yourdomain.com'
MANYCOMM_INFO_EMAIL = ENV['MANYCOMM_INFO_EMAIL'] || 'someone@yourdomain.com'
MANYCOMM_DEV_EMAIL = ENV['MANYCOMM_DEV_EMAIL'] || 'dev@yourdomain.com'

MANYCOMM_BASE_URL = if Rails.env.production? || Rails.env.staging?
                      ENV['MANYCOMM_BASE_URL']
                    elsif Rails.env.test?
                      'http://the_reset_url'
                    else
                      ENV['MANYCOMM_BASE_URL'] || 'http://localhost:3000'
                    end

TWILIO_API_KEY = ENV['TWILIO_API_KEY'] || '*****YOUR API KEY*****'
TWILIO_API_SECRET = ENV['TWILIO_API_SECRET'] || '*****YOUR API SECRET*****'
TWILIO_ACCOUNT_SID = ENV['TWILIO_ACCOUNT_SID'] || '*****YOUR ACCOUNT SID*****'
