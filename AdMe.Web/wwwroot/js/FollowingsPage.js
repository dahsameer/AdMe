$(document).ready(function () {
    var userid = $("#followbutton").data("userid");
    $.ajax({
        url: "/Timeline/GetFollowings",
        method: "GET",
        data: { UserId: userid },
        success: function (Users) {
            debugger;
            $.each(Users, function (i, k) {
                var html = `<div style="display:none;" class="followcard" class="col-md-6 col-sm-6">
                                <div class="friend-card">
                                    <img src="images/covers/1.jpg" alt="profile-cover" class="img-responsive cover" />
                                    <div class="card-info">
                                        <img src="images/users/user-3.jpg" alt="user" class="profile-photo-lg" />
                                        <div class="friend-info">
                                            <a href="#" class="pull-right text-green">My Friend</a>
                                            <h5><a href="/user/${k.username}" class="profile-link">${k.fullname}</a></h5>
                                            <p>${k.email}</p>
                                        </div>
                                    </div>
                                </div>
                            </div>`;
                $("#friendList").append(html);
                $(".followcard").show("slow");
            });
        }
    });
});