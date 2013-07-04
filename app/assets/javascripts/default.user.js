/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
$('document').ready(function() {
  $('#gnib-thumbnail').click(function() {
    $(this).hide();
    //send ajax request to server to indicate that we have read the notification
    var not_id = $(this).data('notification-id');
    var action = '/users/readnotifications';
    var data = {notification_id: not_id};
    doAjaxSubmit(data, action);
  });
});

function doAjaxSubmit(data, url, callback) {
  $.ajax({
    type: 'GET',
    url: url,
    data: data,
    success: function(response) {
      if (callback) {
        callback(response);
      }
    }
  });
  return false; //if called within a form in order to avoid default form submit
}
;

