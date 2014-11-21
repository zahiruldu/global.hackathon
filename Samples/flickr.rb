# Flickr is an image hosting and video 
# hosting website, and web services suite
#
# This example uses a third-party ruby library to authenticate a user
# and output the most recent photo.
#
# Please see these for more information:
#
# https://www.flickr.com/services/developer
# https://github.com/hanklords/flickraw

require 'flickraw'

FlickRaw.api_key="YOUR_API_KEY"
FlickRaw.shared_secret="YOUR_APP_SECRET"

list   = flickr.photos.getRecent

id     = list[0].id
secret = list[0].secret
info = flickr.photos.getInfo :photo_id => id, :secret => secret

puts info.title
puts info.dates.taken

sizes = flickr.photos.getSizes :photo_id => id

original = sizes.find {|s| s.label == 'Original' }
puts original.width