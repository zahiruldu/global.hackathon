<?php
# Instagram is an online mobile photo-sharing, 
# video-sharing and social networking service that 
# enables its users to take pictures and videos, 
# and share them on a variety of social networking platforms.
#
# This example uses a third-party PHP library to authenticate a user
# and to output the most popular media.
#
# Please see these for more information:
#
# http://instagram.com/developer/
# https://github.com/cosenary/Instagram-PHP-API

require_once 'Instagram.php';
use MetzWeb\Instagram\Instagram;

$instagram = new Instagram(array(
  'apiKey'      => 'YOUR_APP_KEY',
  'apiSecret'   => 'YOUR_APP_SECRET',
  'apiCallback' => 'YOUR_APP_CALLBACK'
));

$result = $instagram->getPopularMedia();

foreach ($result->data as $media) {
    $content = "<li>";
    // output media
    if ($media->type === 'video') {
      // video
      $poster = $media->images->low_resolution->url;
      $source = $media->videos->standard_resolution->url;
      $content .= '<video width="250" height="250" poster="' . $poster . '"
                   data-setup="{"controls":true, "preload": "auto"}">
                     <source src="' . $source . '" type="video/mp4" />
                   </video>';
    } else {
      // image
      $image = $media->images->low_resolution->url;
      $content .= '<img class="media" src="' . $image . '"/>';
    }
    // create meta section
    $avatar = $media->user->profile_picture;
    $username = $media->user->username;
    $comment = (!empty($media->caption->text)) ? $media->caption->text : '';
    $content .= '<div class="content">
                   <div class="avatar" style="background-image: url(' . $avatar . ')"></div>
                   <p>' . $username . '</p>
                   <div class="comment">' . $comment . '</div>
                 </div>';
    // output media
    echo $content . "</li>";
}
?>