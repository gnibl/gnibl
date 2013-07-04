/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

$('document').ready(function() {
  $('.notification-overlay-gnib-thumbnail').click(function() {
    $(this).hide();
    //send ajax request to server to indicate that we have read the notification
    console.log('sending notification read');
    var not_id = $(this).data('notification-id');
    console.log('notification:id: ' + not_id);
    var action = '/users/readnotifications';
    var data = {notification_id: not_id};
    doAjaxSubmit(data, action);
  });
});

function doAjaxSubmit(data, url, callback) {
  $('body').css('cursor', 'wait');
  $.ajax({
    type: 'GET',
    url: url,
    data: data,
    success: function(response) {
      if (callback) {
        callback(response);
      }
      $('body').css('cursor', 'auto');
    }
  });
  return false; //if called within a form in order to avoid default form submit
}
;

