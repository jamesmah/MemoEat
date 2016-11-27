// Collapse panels when switching from mobile to desktop views
$(window).resize(function() {
  if ( $(window).width() < 768 ) {
    // Find cards with open body panels
    var $panelHeadingOpen = $(".restaurant-card .panel-heading:not([data-toggle])");
    var $memoCollapseOpen = $panelHeadingOpen.closest('.panel').find('.panel-collapse');

    $memoCollapseOpen.removeClass("in");
    $panelHeadingOpen.attr("data-toggle", "collapse");
    $(".restaurant-card .panel-heading").mouseenter( function() {
      document.body.style.cursor = "pointer";
    } ).mouseleave( function() {
      document.body.style.cursor = "auto";
    } );
  }
  else {
    // Find cards with closed body panels
    var $panelHeadingClosed = $(".restaurant-card div.panel-heading[data-toggle='collapse']");
    var $memoCollapseClosed = $panelHeadingClosed.closest('.panel').find('.panel-collapse');

    $memoCollapseClosed.addClass("in");
    $panelHeadingClosed.removeAttr("data-toggle");
    $(".restaurant-card .panel-heading").mouseenter( function() {
      document.body.style.cursor = "auto";
    } ).mouseleave( function() {
      document.body.style.cursor = "auto";
    } );
  }
});
$(window).trigger('resize');

// Form and button event handlers
$('.rating button').click(function(event) {
  event.preventDefault();
  id = find_id(event);
  rating = $(event.target).closest('form').find('input[name="rating"]').val();

  $.ajax({
    method: 'PATCH',
    url: '/api/restaurant/' + id,
    data: { rating: rating }
  }).done(function(response) {
    restaurant = JSON.parse(response);

    $buttons = $(event.target).closest('.rating').find('button');
    for (var i = 1; i <= 5; i++) {
      if ( !!restaurant.rating && i <= restaurant.rating ) {
        $($buttons[i-1]).css('background-image','url(/images/rating_filled.png)');
      }
      else {
        $($buttons[i-1]).css('background-image','url(/images/rating_empty.png)');
      }
    }
  });
});

$('.notes form').submit(function(event) {
  event.preventDefault();
  id = find_id(event);
  notes = $(event.target).find('textarea[name="notes"]').val();

  $.ajax({
    method: 'PATCH',
    url: '/api/restaurant/' + id,
    data: { notes: notes }
  }).done(function(response) {
    restaurant = JSON.parse(response);
      if (restaurant.notes === notes) {
        $(event.target).closest('.notes').find('button').text("Saved!");
      }
  });
});

$('.add-btn').click(function(event) {
  event.preventDefault();
  $form = $(event.target).closest(".add-form");

  $.ajax({
    method: 'POST',
    url: '/api/restaurant',
    data: { 
      zomato_id: $form.find("input[name='zomato_id']").val(),
      name: $form.find("input[name='name']").val(),
      address: $form.find("input[name='address']").val(),
      cuisines: $form.find("input[name='cuisines']").val(),
      price_range: $form.find("input[name='price_range']").val(),
      photo_url: $form.find("input[name='photo_url']").val(),
      rating: $form.find("input[name='rating']").val(),
      notes: $form.find("input[name='notes']").val()
    }
  }).done(function(response) {
    data = JSON.parse(response);
    if (data.success) {
      $(event.target).text('Added!').attr('type','button');
    }
  });
});

$('.delete-btn').click(function(event) {
  event.preventDefault();
  id = find_id(event);

  $.ajax({
    method: 'DELETE',
    url: '/api/restaurant/' + id
  }).done(function(response) {
    data = JSON.parse(response);
    if (data.success) {
      $(event.target).closest('.restaurant-card').remove();
    }
  });
});

$('.archive-btn').click(function(event) {
    event.preventDefault();
    id = find_id(event);

    $.ajax({
        method: 'PATCH',
        url: '/api/restaurant/' + id,
        data: { archive: true }
    }).done(function(response) {
        restaurant = JSON.parse(response);
        if (restaurant.archive === true) {
          $(event.target).closest('.restaurant-card').remove();
        }
    });
});

$('.unarchive-btn').click(function(event) {
    event.preventDefault();
    id = find_id(event);

    $.ajax({
        method: 'PATCH',
        url: '/api/restaurant/' + id,
        data: { archive: false }
    }).done(function(response) {
        restaurant = JSON.parse(response);
        if (restaurant.archive === false) {
          $(event.target).closest('.restaurant-card').remove();
        }
    });
});

function find_id(event) {
  return $(event.target).closest('.restaurant-card').find('input[name="id"]').val();
}

$('.prevent-enter-key').on('keydown keypress', function(event) {
  if (event.keyCode === 13) { 
    event.preventDefault();
  }
});