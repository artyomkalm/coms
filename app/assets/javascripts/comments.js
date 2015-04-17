function rm_new_comment_panel() {
  $('.child_comment').fadeOut().remove();
  $('.replied').removeClass('replied');
}

function rm_edit_comment_panel() {
  $('.edit').fadeOut().remove();
  $('.edited').removeClass('edited');
  $('.edited_body').removeClass('edited_body');
}

$(document).on("ajax:success", "#new_comment", function(evt, data, status, xhr){
  if ($('.child_comment').length) {
    $(data).appendTo('.replied .children').hide().fadeIn();
    rm_new_comment_panel();
  }
  else {
    $(data).prependTo('#comments').hide().fadeIn();
    $('#comment_body').val('');
  }
});

$(document).on('ajax:beforeSend', '.reply', function(evt, xhr, settings) {
  rm_new_comment_panel();
  $(this).closest('div[id^="comment"]').addClass('replied');
});

$(document).on('ajax:success', '.reply', function(evt, data, status, xhr) {
  $(data).addClass('child_comment').insertAfter('.replied').hide().fadeIn();
});

$(document).on('ajax:success', '.delete_comment', function(evt, xhr, settings) {
  var comment = "#comment_" + xhr.id;
  $(this).closest(comment).fadeOut();
});

$(document).on('ajax:beforeSend', '.edit_comment_url', function(evt, xhr, settings) {
  rm_new_comment_panel();
  var comment = $(this).closest('div[id^="comment"]');
  comment.addClass('edited');
  comment.find('.comment_body:first').addClass('edited_body');
});

$(document).on('ajax:success', '.edit_comment_url', function(evt, data, status, xhr) {
  $(data).addClass('edit').insertAfter('.edited').hide().fadeIn();
});

$(document).on('ajax:success', '.edit', function(evt, data, status, xhr) {
  $('.edited .edited_body').text(xhr.responseJSON.body);
  rm_edit_comment_panel();
});