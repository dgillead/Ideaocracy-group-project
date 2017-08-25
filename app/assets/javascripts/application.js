// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require turbolinks
//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require local-time
//= require_tree .

function authenticateTrello() {
  localStorage.removeItem('trello_token');
  Trello.authorize({
    name: "YourApplication",
    type: "popup",
    interactive: true,
    expiration: "never",
    persist: true,
    success: function () { onAuthorizeSuccessful(); },
    scope: { write: true, read: true },
  });
}

function onAuthorizeSuccessful() {
  var token = Trello.token();
  window.location.replace("/auth?token=" + token);
}

$(document).ready(function () {
  $('.thumbs-up').on('click', function(e) {
    e.preventDefault();
    let voteCountDB = $(this).parent().parent().find('#vote-count').attr('data-vote-count')
    let suggestionId = $(this).parent().parent().find('#vote-count').attr('data-suggestion-id');
    let voteCount = parseInt($(this).parent().parent().find('#vote-count').text(), 10);
    if (voteCount == voteCountDB){
      $(this).attr('class', "thumbs-up suggestion-icon fa fa-thumbs-up")
      $(this).siblings('i').attr('class', "thumbs-down suggestion-icon fa fa-thumbs-o-down")
      voteCount++;
      $(this).parent().parent().find('#vote-count').text(voteCount.toString());
      jQuery.ajax({url: `/upvote?suggestion_id=${suggestionId}`, type: 'patch'});
    }
  }); 
});

$(document).ready(function () {
  $('.thumbs-down').on('click', function(e) {
    e.preventDefault();
    let voteCountDB = $(this).parent().parent().find('#vote-count').attr('data-vote-count')
    let suggestionId = $(this).parent().parent().find('#vote-count').attr('data-suggestion-id');
    let voteCount = parseInt($(this).parent().parent().find('#vote-count').text(), 10);
    if (voteCount == voteCountDB){
      $(this).attr('class', "thumbs-down suggestion-icon fa fa-thumbs-down")
      $(this).siblings('i').attr('class', "thumbs-down suggestion-icon fa fa-thumbs-o-up")
      voteCount--;
      $(this).parent().parent().find('#vote-count').text(voteCount.toString());
      jQuery.ajax({url: `/downvote?suggestion_id=${suggestionId}`, type: 'patch'});
    }
  }); 
});



