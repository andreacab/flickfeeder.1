var ready;
ready = function() {
  $(".feature-container :checkbox").bootstrapSwitch().on('switchChange.bootstrapSwitch', function(event, state) {
    var data = {};
    data[this.name] = state;
    $.ajax({
      url: '/application_settings/update',
      type: 'PATCH',
      data: data,
      success: function() {
       $('.sidebar').load(document.URL +  ' .sidebar'
      );}
    });
  });
};

$(document).ready(ready);
$(document).on('page:load', ready);
