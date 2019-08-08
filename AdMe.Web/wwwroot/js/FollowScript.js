$(document).ready(function () {
    debugger;
    var userid = $("#followbutton").data("userid");
    $.ajax({
        url: "/Timeline/GetFollowButtonText",
        method: "GET",
        data: { userId: userid },
        success: function (response) {
            $("#followbutton").text(response.responseMessage);
        },
        error: function (response) {
            console.log(response);
        }
    });

    $("#followbutton").click(function () {
        if ($(this).text() == "Edit") {
            window.location.href = "/Timeline/Edit";
        }
        $.ajax({
            url: "/Timeline/ToggleButton",
            method: "POST",
            data: { userId: userid },
            success: function (response) {
                $("#followbutton").text(response.responseMessage);
            },
            error: function (response) {
                console.log(response);
            }
        });
    });
});