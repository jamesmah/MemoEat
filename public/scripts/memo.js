$(window).resize(function() {

if ($(window).width() < 768) {
    $( "div.memo-collapse" ).removeClass("in");
    $( "div.panel-heading").attr("data-toggle", "collapse");
    $( "div.panel-heading" ).mouseenter( function() {
        document.body.style.cursor = "pointer";
    } ).mouseleave( function() {
        document.body.style.cursor = "auto";
    } );
}
else
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



var hover_img_url = '';

$(".rating button").mouseenter( function() {
        hover_img_url = $(event.target).css("background-image");
        $(event.target).css("background-image", "url(/images/star2.png)");
    } ).mouseleave( function() {
        $(event.target).css("background-image", hover_img_url);
    } );