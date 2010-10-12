$(document).ready(function() {
    var textchange_timeout;

    $("#left, #right").bind("textchange",
    function(event, previousText) {
        clearTimeout(textchange_timeout);
        textchange_timeout = setTimeout(function() {
            alert("saved!")
        },
        1000);
    });
});