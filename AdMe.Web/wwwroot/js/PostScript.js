var config = {
    NewsfeedType: 'C',
    PostType: 'F',
    PostList: []
};

$(document).ready(function () {
    GetPostList(null);

    function GetPostList(previousPostId) {
        $.ajax({
            url: "/Post/GetNewsfeedPost",
            data: { previousPost: previousPostId, newsType: config.NewsfeedType },
            method: "GET",
            success: function (Posts) {
                config.PostList = Posts;
            },
            error: function (error) {
                console.log("Error fetching post from the server");
            }
        }).done(FetchPost);
    }

    function FetchPost() {
        $.each(config.PostList, function (i,k) {
            var request = AddPost(k);
        });
    }

    function AddPost(postId, fresh) {
        return $.ajax({
            url: "/Post/GetPostById",
            data: { postId: postId, allReply: config.PostType },
            async: false,
            method: "GET",
            success: function (Post) {
                var postHtml = `
                    <div class="post-content" style="display: none;" data-postid="${Post.postId}">
                        <div class="post-container">
                            <img src="${Post.photo}" alt="user" class="profile-photo-md pull-left" />
                            <div class="post-detail">
                                <div class="user-info">
                                    <h5><a href="/user/${Post.username}" class="profile-link">${Post.fullname}</a></h5>
                                    <p class="text-muted">${Post.postedTime}</p>
                                </div>
                                <div class="reaction">
                                    <a class="btn ${Post.responseId} likebutton"><i class="icon ion-thumbsup"></i> ${Post.likes}</a>
                                </div>
                                <div class="line-divider"></div>
                                <div class="post-text">
                                    <p>${Post.postContent}</p>
                                </div>
                                <div class="line-divider"></div>
                                <div class="ReplyField">
                `;
                $.each(Post.replies, function (i, k) {
                    postHtml += `
                                <div class="post-comment">
                                    <img src="${k.photo}" alt="" class="profile-photo-sm" />
                                    <p><a href="/user/${k.username}" class="profile-link">${k.fullname} </a> ${k.postContent}</p>
                                </div >
                `;
                });
                postHtml += `
                                </div>
                                <div class="post-comment">
                                    <img src="${userphoto}" alt="" class="profile-photo-sm" />
                                    <input type="text" class="form-control ReplyBox" placeholder="Post a comment">
                                </div>
                            </div>
                        </div>
                        <div class="post-content">
                            <div class="post-container">
                                <div class="post-detail">
                                    <pre> Affinity Score : ${Post.affinityScore}  Epsilon : ${Post.epsilon}  Gamma : ${Post.gamma}  TimeDecay : ${Post.timeDecay}  PostWeight : ${Post.postWeight} </pre>
                                </div>
                            </div>
                        </div>
                    </div>
                `;
                if (fresh) {
                    $("#PostViewDiv").prepend(postHtml);
                }
                else {
                    $("#PostViewDiv").append(postHtml);
                }
                $(".post-content").show('slow');
            },
            error: function (error) {
                console.log("Some error occured while fetching the post");
            }
        });
    }

    $("#postSubmitButton").click(function () {
        $("#postSubmitButton").attr("disabled", true);
        var PostContent = $("#postCreateBox").val();
        if (PostContent.trim() == "") {
            $("#postSubmitButton").attr("disabled", false);
            return;
        }
        $.ajax({
            url: "/Post/AddPost",
            data: { postContent: PostContent },
            method: "POST",
            success: function (postid) {
                AddPost(postid, true);
                $("#postCreateBox").val("");
            },
            error: function () {
                console.log("Post Error");
            },
            complete: function () {
                $("#postSubmitButton").attr("disabled", false);
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

    $("#LoadMore").click(function () {
        var lastPost = $("#PostViewDiv").children().last().data("postid");
        GetPostList(lastPost);
    });

    $("#PostViewDiv").on('click', '.likebutton',function () {
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
});