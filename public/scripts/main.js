$(document).ready(function() {
    var textchange_timeout;

    $("#left, #right").bind("textchange",
    function(event, previousText) {
        clearTimeout(textchange_timeout);
        textchange_timeout = setTimeout(function() {
            postText();
        },
        1000);
    });
});

function postText() {
    var left = $("#left").text();
    var right = $("#right").text();
}