TextDiffer = {
    textchange_timeout: null,

    initialize: function() {
        TextDiffer.left_result = $("#left_result");
        TextDiffer.right_result = $("#right_result");
        TextDiffer.left_text_area = $("#left_text_area");
        TextDiffer.right_text_area = $("#right_text_area");

        TextDiffer.left_result.hide();
        TextDiffer.right_result.hide();
        TextDiffer.left_result.click(TextDiffer.toggleTextAreas);
        TextDiffer.right_result.click(TextDiffer.toggleTextAreas);
        TextDiffer.left_text_area.bind("textchange", TextDiffer.onTextChange);
        TextDiffer.right_text_area.bind("textchange", TextDiffer.onTextChange);

        $("#diff").click(function()
        {
	TextDiffer.toggleTextAreas();
            TextDiffer.postText();
        });


    },

    onTextChange: function() {
        clearTimeout(TextDiffer.textchange_timeout);
        TextDiffer.textchange_timeout = setTimeout(function() {
            TextDiffer.postText();
        },
        1000);
    },

    toggleTextAreas: function() {
        TextDiffer.left_result.toggle();
        TextDiffer.right_result.toggle();
        TextDiffer.left_text_area.toggle();
        TextDiffer.right_text_area.toggle();
    },

    postText: function() {
        $.post("/", {
            left: TextDiffer.left_text_area.val(),
            right: TextDiffer.right_text_area.val()
        },
        function(data) {
            var dataObject = eval(data);
            TextDiffer.left_result.html(dataObject.left);
            TextDiffer.right_result.html(dataObject.right);
            TextDiffer.toggleTextAreas();
        },
        "json");
    }
};

$(document).ready(TextDiffer.initialize);