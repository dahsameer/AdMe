$(document).ready(function () {
    $("#PostViewDiv").on('click', '.likebutton', function () {
        var id = $(this).parent().parent().parent().parent().data("postid");
        var like = this;
        $.ajax({
            url: "/Post/ToggleLike",
            method: "POST",
            data: { postid: id },
            success: function (response) {
                $(like).html(`<i class="icon ion-thumbsup"></i> ${response.responseMessage}`);
                $(like).attr("class", `btn ${response.responseId} likebutton`)
            }
        });
    });

    $("#PostViewDiv").on('keypress', '.ReplyBox', function (e) {
        if (e.keyCode == 13) {
            $(this).attr("disabled", true);
            var elem = this;
            var reply = $(this).val();
            var parentId = $(this).parent().parent().parent().parent().data("postid");
            $.ajax({
                url: "/Post/AddReply",
                method: "POST",
                data: { ReplyData: reply, ParentId: parentId },
                success: function (Post) {
                    var html = AddReply(Post);
                    $(elem).parent().prev().append(html);
                    $(elem).parent().prev().find(".post-comment").show("slow");
                    $(elem).val("");
                },
                error: function (err) {
                    console.log("Couldnot add reply ERROR: " + err);
                },
                complete: function () {
                    $(".ReplyBox").attr("disabled", false);
                }
            });
        }
    });

    function AddReply(replyid) {

        var html = "";
        $.ajax({
            url: "/Post/GetPostById",
            data: { postId: replyid, allReply: config.PostType },
            async: false,
            method: "GET",
            success: function (reply) {
                html = ` <div class="post-comment" style="display: none;">
                                    <img src="${reply.photo}" alt="" class="profile-photo-sm" />
                                    <p><a href="/user/${reply.username}" class="profile-link">${reply.fullname} </a> ${reply.postContent}</p>
                         </div >`;
            }
        });
        return html;
    }
});