$( "div.memo-collapse" ).removeClass("in");
$( "div.panel-heading").attr("data-toggle", "collapse");

$(window).resize(function() {

if ($(window).width() < 768 && $(window).width() > 700) {
    $( "div.memo-collapse" ).removeClass("in");
    $( "div.panel-heading").attr("data-toggle", "collapse");
}
if ($(window).width() < 768) {
    $( "div.panel-heading" ).mouseenter( function() {
        document.body.style.cursor = "pointer";
    } ).mouseleave( function() {
        document.body.style.cursor = "auto";
    } );
}
else if ($(window).width() >= 768)
{
    $( "div.memo-collapse" ).addClass("in").css("height","auto");
    
    $( "div.panel-heading").removeAttr("data-toggle");

    $( "div.panel-heading" ).mouseenter( function() {
        document.body.style.cursor = "auto";
    } ).mouseleave( function() {
        document.body.style.cursor = "auto";
    } );
  }
});


$(window).trigger('resize');



// var hover_img_url = '';

// $(".rating button").mouseenter( function() {
//         hover_img_url = $(event.target).css("background-image");
//         $(event.target).css("background-image", "url(/images/star2.png)");
//     } ).mouseleave( function() {
//         $(event.target).css("background-image", hover_img_url);
//     } );


$('.rating button').click(function(event) {
    event.preventDefault();
    id = $(event.target).closest('.restaurant-item').find('input[name="id"]').val();
    rating = $(event.target).closest('form').find('input[name="rating"]').val();

    $.ajax({
        method: 'patch',
        url: '/api/restaurant/' + id,
        data: { rating: rating }
    }).done(function(response) {
        restaurant = JSON.parse(response);

        $buttons = $(event.target).closest('.rating').find('button');

        for (var i = 0; i < 5; i++) {

            if (restaurant.rating === undefined || i > restaurant.rating-1) {
                $($buttons[i]).css('background-image','url(/images/star1.png)');
            }
            else {
                $($buttons[i]).css('background-image','url(/images/star2.png)');
            }
        }
    });
});

$('.notes form').submit(function(event) {
    event.preventDefault();
    id = $(event.target).closest('.restaurant-item').find('input[name="id"]').val();
    notes = $(event.target).find('textarea[name="notes"]').val();

    $.ajax({
        method: 'patch',
        url: '/api/restaurant/' + id,
        data: { notes: notes }
    }).done(function(response) {
        $(event.target).closest('.notes').find('button').text("Saved!");
    });
});

$('.add-btn').click(function(event) {
    event.preventDefault();
    $form = $(event.target).closest(".add-form");

    $.ajax({
        method: 'post',
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
        if (data.saved === true) {
            $(event.target).text('Added!').attr('type','button');
        }
    });
});

$('.delete-btn').click(function(event) {
    event.preventDefault();
    id = $(event.target).closest('.restaurant-item').find('input[name="id"]').val();
    $.ajax({
        method: 'delete',
        url: '/api/restaurant/' + id
    }).done(function(response) {
        $(event.target).closest('.restaurant-item').remove();
    });
    
});


$('.archive-btn').click(function(event) {
    event.preventDefault();

    id = $(event.target).closest('.restaurant-item').find('input[name="id"]').val();
    $.ajax({
        method: 'patch',
        url: '/api/restaurant/' + id,
        data: { archive: true }
    }).done(function(response) {
        $(event.target).closest('.restaurant-item').remove();
    });
});


$('.unarchive-btn').click(function(event) {
    event.preventDefault();

    id = $(event.target).closest('.restaurant-item').find('input[name="id"]').val();
    $.ajax({
        method: 'patch',
        url: '/api/restaurant/' + id,
        data: { archive: false }
    }).done(function(response) {
        $(event.target).closest('.restaurant-item').remove();
    });
});