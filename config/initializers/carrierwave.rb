CarrierWave.configure do |config|

config.root = "#{Rails.root}/tmp"
config.cache_dir = "carrierwave"

 config.fog_credentials = {
    :provider               => 'TRW',                        # required
    :aws_access_key_id      => 'sajdhasas8u8923nfkcljjauiruwcnjf',                        # required
    :aws_secret_access_key  => 'dfhsdkjfhwierlsdfiofnjsdbfsdl;njk',                        # required
    :region                 => '7236jksfbjsd',                  # optional, defaults to 'us-east-1'
  # :host                   => 's3-website-eu-west-1.amazonaws.com',             # optional, defaults to nil
 #   :endpoint               => '' # optional, defaults to nil. will screw me big time
  }
  config.fog_directory  = 'gniblpics'                     # required
#  config.fog_public     = false                                   # optional, defaults to true
  config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
end
