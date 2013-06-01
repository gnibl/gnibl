CarrierWave.configure do |config|

config.root = "#{Rails.root}/tmp"
config.cache_dir = "carrierwave"

 config.fog_credentials = {
    :provider               => 'AWS',                        # required
    :aws_access_key_id      => 'AKIAINZNZNMGHHBCEBPQ',                        # required
    :aws_secret_access_key  => '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',                        # required
    :region                 => 'eu-west-1',                  # optional, defaults to 'us-east-1'
  # :host                   => 's3-website-eu-west-1.amazonaws.com',             # optional, defaults to nil
 #   :endpoint               => '' # optional, defaults to nil. will screw me big time
  }
  config.fog_directory  = 'gniblpics'                     # required
#  config.fog_public     = false                                   # optional, defaults to true
  config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
end
