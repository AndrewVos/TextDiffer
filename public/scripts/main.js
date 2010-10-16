TextDiffer = {
    initialize: function() {
        TextDiffer.left_result = $("#left_result");
        TextDiffer.right_result = $("#right_result");
        TextDiffer.left_text_area = $("#left_text_area");
        TextDiffer.right_text_area = $("#right_text_area");
        TextDiffer.diff = $("#diff");
        TextDiffer.edit = $("#edit");

        TextDiffer.showTextAreas();
        TextDiffer.diff.click(TextDiffer.postText);
        TextDiffer.edit.click(TextDiffer.showTextAreas)
    },

    showTextAreas: function() {
        TextDiffer.left_result.hide();
        TextDiffer.right_result.hide();
        TextDiffer.left_text_area.show();
        TextDiffer.right_text_area.show();
        TextDiffer.diff.show();
        TextDiffer.edit.hide();
    },

    hideTextAreas: function() {
        TextDiffer.left_result.show();
        TextDiffer.right_result.show();
        TextDiffer.left_text_area.hide();
        TextDiffer.right_text_area.hide();
        TextDiffer.diff.hide();
        TextDiffer.edit.show();
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
            TextDiffer.hideTextAreas();
        },
        "json");
    }
};

$(document).ready(TextDiffer.initialize);