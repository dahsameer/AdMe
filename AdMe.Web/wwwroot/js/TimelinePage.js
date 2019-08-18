
var config = {
    NewsfeedType: 'C',
    PostType: 'F',
    PostList: []
};

$(document).ready(function () {
    debugger;
    var userid = $("#followbutton").data("userid");
    GetPostList(userid, null);

    function GetPostList(userid, previousPostId) {
        $.ajax({
            url: "/Post/GetTimelinePosts",
            data: { user: userid, previousPost: previousPostId },
            method: "GET",
            async: false,
            success: function (Posts) {
                config.PostList = Posts;
            },
            error: function (error) {
                console.log("Error fetching post from the server");
            }
        }).done(FetchPost);
    }

    function FetchPost() {
        $.each(config.PostList, function (i, k) {
            var request = AddPost(k);
        });
    }

    async function AddPost(postId, fresh) {
        return $.ajax({
            url: "/Post/GetPostById",
            data: { postId: postId, allReply: config.PostType },
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
                                    <a class="btn ${Post.responseId} likebutton" ><i class="icon ion-thumbsup"></i> ${Post.likes}</a>
                                </div>
                                <div class="line-divider"></div>
                                <div class="post-text">
                                    <p>${Post.postContent}</p>
                                </div>
                                <div class="line-divider"></div>
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
                                <div class="post-comment">
                                    <img src="${userphoto}" alt="" class="profile-photo-sm" />
                                    <input type="text" class="form-control ReplyBox" placeholder="Post a comment">
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
});