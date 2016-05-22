// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap
//= require bootstrap-switch

//= require react
//= require react_ujs
//= require components
//= require_tree .



var ready;
ready = function() {

  // LOADER
  $('.menu-item').on('click', function() {
    $('.box-wrapper').fadeIn(200);
  });
  $('.box-wrapper').fadeOut(100);

  // COG | NAVBAR
  $('.nav-cog, #admin-tools').on('click', function(){
    $(this).addClass('fa-spin');
  });

  // SIGNUP LOGIC
  $('input').on('change keyup', function() {
    if ($('#user_email').val().length > 0 && $('#user_password').val().length > 0 && $('#user_password_confirmation').val().length > 0 ){
      $('.sign-up-button').prop('disabled', false);
    } else {
      $('.sign-up-button').prop('disabled', true);
    }
  });

  $('.sign-up-button').on('click', function(){
     $('.basic-information').fadeOut(0);
     $('.extra-information').fadeIn(0);
     $('.sign-up-button').val("Sign up");
  });

};

$(document).ready(ready);
$(document).on('page:load', ready);
