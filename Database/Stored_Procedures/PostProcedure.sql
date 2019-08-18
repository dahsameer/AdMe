CREATE OR ALTER PROCEDURE PostProcedure (
    @Flag NVARCHAR(20) = NULL, 
	@Username NVARCHAR(100) = NULL, 
	@PostContent NVARCHAR(2000) = NULL,
    @PostId NVARCHAR(50) = NULL,
	@ParentPostId NVARCHAR(50) = NULL,
	@AllReplies bit = NULL,
	@UserId INT = NULL,
	@Extra NVARCHAR(50) = 'text-green',
	@PostKeywords NVARCHAR(500) = NULL,
	@Search NVARCHAR(100) = NULL
	)
AS
SET NOCOUNT ON;
BEGIN
    BEGIN TRY
        IF @Flag = 'CheckPostId'
        BEGIN
            IF NOT EXISTS (SELECT 'A' FROM dbo.tblPost WHERE PostId = @PostId)
            BEGIN
                SELECT 100 AS ResponseCode, 'Post Id does not exists' AS ResponseMessage, '' AS ResponseId;
            END;
            ELSE
            BEGIN
                SELECT 101 AS ResponseCode, 'Post Id exists' AS ResponseMessage, '' AS ResponseId;
            END;
        END;
		IF @Flag = 'AddPost'
		BEGIN
			SELECT @UserId=Id FROM dbo.tblUser WHERE Username=@Username;
		    INSERT INTO dbo.tblPost (PostId, PostParent, PostContent, Poster, PostKeywords, PostedTime)
		    VALUES (@PostId,       -- PostId - varchar(50)
		            @ParentPostId,       -- PostParent - varchar(50)
		            @PostContent,      -- PostContent - nvarchar(2000)
		            @UserId,        -- Poster - int
					@PostKeywords,
		            GETDATE() -- PostedTime - datetime
		        )
			SELECT 100 AS ResponseCode, 'Successfully posted' AS ResponseMessage, @PostId AS ResponseId;
		END
		IF @Flag = 'AddReply'
		BEGIN
			SELECT @UserId=Id FROM dbo.tblUser WHERE Username=@Username;
		    INSERT INTO dbo.tblPost (PostId, PostParent, PostContent, Poster, PostedTime, PostKeywords)
		    VALUES (@PostId,       -- PostId - varchar(50)
		            @ParentPostId,       -- PostParent - varchar(50)
		            @PostContent,      -- PostContent - nvarchar(2000)
		            @UserId,        -- Poster - int
		            GETDATE(), -- PostedTime - datetime
					@PostKeywords
		        )
			SELECT 100 AS ResponseCode, 'Successfully posted' AS ResponseMessage, @PostId AS ResponseId;
		END
		IF @Flag = 'GetPost'
		BEGIN
			SELECT @UserId=Id FROM dbo.tblUser WHERE Username=@Username
			SELECT tp.PostId, tp.PostParent, tp.PostContent, tp.Poster, tp.PostedTime, tp.PostKeywords,
                   tf.AffinityScore, 0 AS Interacted
			FROM dbo.tblPost tp 
			INNER JOIN dbo.tblFollow tf 
			ON tp.Poster = tf.FollowedUser 
			WHERE tf.FollowedBy=@UserId AND tp.PostId NOT IN (SELECT p.PostId FROM dbo.tblPost p INNER JOIN dbo.tblLike l ON l.PostId = p.PostId WHERE l.LikedBy=@UserId)
			AND tp.PostId NOT IN (SELECT p1.PostId FROM dbo.tblPost p1 INNER JOIN dbo.tblPost p2 ON p1.PostId = p2.PostParent WHERE p2.Poster=@UserId) AND tp.PostParent IS NULL UNION

			SELECT *, 0.5 AS AffinityScore, 1 AS Interacted FROM dbo.tblPost WHERE Poster=@UserId AND PostParent IS NULL UNION
			SELECT tp.PostId, tp.PostParent, tp.PostContent, tp.Poster, tp.PostedTime, tp.PostKeywords,
			tf.AffinityScore, 1 AS Interacted FROM dbo.tblPost tp INNER JOIN dbo.tblFollow tf ON tp.Poster=tf.FollowedUser WHERE tp.PostParent IS NULL AND tp.PostId IN (SELECT p.PostId FROM dbo.tblPost p INNER JOIN dbo.tblLike l ON l.PostId = p.PostId WHERE l.LikedBy=@UserId) UNION
			SELECT tp.PostId, tp.PostParent, tp.PostContent, tp.Poster, tp.PostedTime, tp.PostKeywords,
			tf.AffinityScore, 1 AS Interacted FROM dbo.tblPost tp INNER JOIN dbo.tblFollow tf ON tp.Poster=tf.FollowedUser WHERE tp.PostParent IS NULL AND tp.PostId IN (SELECT p1.PostId FROM dbo.tblPost p1 INNER JOIN dbo.tblPost p2 ON p1.PostId = p2.PostParent WHERE p2.Poster=@UserId)
		END
		IF @Flag='GetKeywords'
		BEGIN
		SET @Username='dahsameer'
			SELECT @UserId=Id FROM dbo.tblUser WHERE Username=@Username
		    SELECT p.PostKeywords FROM dbo.tblPost p INNER JOIN dbo.tblLike l ON l.PostId = p.PostId WHERE l.LikedBy=@UserId UNION
			SELECT PostKeywords FROM dbo.tblPost WHERE Poster=@UserId AND PostParent IS NOT NULL;
		END
		IF @Flag='GetTimelinePost'
		BEGIN
		    SELECT PostId FROM dbo.tblPost WHERE Poster=@UserId ORDER BY PostedTime
		END
		IF @Flag = 'GetPostById'
		BEGIN
			SELECT @UserId=Id FROM dbo.tblUser WHERE Username=@Username;
			IF EXISTS(SELECT 'A' FROM dbo.tblLike WHERE PostId=@PostId AND LikedBy=@UserId)
			BEGIN
			    SET @Extra='text-blue';
			END
		    SELECT tp.PostId, tp.PostContent, tu.Username, tu.Fullname, tp.PostedTime, tu.Photo, (SELECT COUNT(LikeId) FROM dbo.tblLike WHERE PostId=@PostId) AS Likes,
				@Extra AS ResponseId
			FROM dbo.tblPost tp 
			INNER JOIN dbo.tblUser tu ON tu.Id = tp.Poster 
			WHERE tp.PostId=@PostId
			ORDER BY tp.PostedTime
		END
		IF @Flag = 'GetRepliesForPost'
		BEGIN
			IF @AllReplies = 1
			BEGIN
				SELECT tp.PostId, tp.PostContent, tu.Username, tu.Fullname, tp.PostedTime, tu.Photo
				FROM dbo.tblPost tp 
				INNER JOIN dbo.tblUser tu ON tu.Id = tp.Poster 
				WHERE tp.PostParent=@PostId
				ORDER BY tp.PostedTime
			END
			ELSE
            BEGIN
                SELECT TOP(2) tp.PostId, tp.PostContent, tu.Username, tu.Fullname, tp.PostedTime , tu.Photo
				FROM dbo.tblPost tp 
				INNER JOIN dbo.tblUser tu ON tu.Id = tp.Poster 
				WHERE tp.PostParent=@PostId
				ORDER BY tp.PostedTime
            END
		END
		IF @Flag='CheckLike'
		BEGIN
			SELECT @UserId=Id FROM dbo.tblUser WHERE Username=@Username
		    IF NOT EXISTS (SELECT 'A' FROM dbo.tblLike WHERE PostId = @PostId AND LikedBy=@UserId)
            BEGIN
                SELECT 100 AS ResponseCode, 'Like Id does not exists' AS ResponseMessage, '' AS ResponseId;
            END;
            ELSE
            BEGIN
                SELECT 101 AS ResponseCode, 'Like Id exists' AS ResponseMessage, '' AS ResponseId;
            END;
		END
		IF @Flag='ToggleLike'
		BEGIN
			SELECT @UserId=Id FROM dbo.tblUser WHERE Username=@Username
		    IF EXISTS(SELECT 'A' FROM dbo.tblLike WHERE PostId=@PostId AND LikedBy=@UserId)
			BEGIN
				DELETE FROM dbo.tblLike WHERE PostId=@PostId AND LikedBy=@UserId
			    SELECT 100 AS ResponseCode, (SELECT COUNT(LikeId) FROM dbo.tblLike WHERE PostId=@PostId) AS ResponseMessage, 'text-green' AS ResponseId;
			END
			ELSE
            BEGIN
				INSERT dbo.tblLike (PostId, LikedBy, LikedTime)
				VALUES (@PostId,@UserId,GETDATE())
                SELECT 101 AS ResponseCode, (SELECT COUNT(LikeId) FROM dbo.tblLike WHERE PostId=@PostId) AS ResponseMessage, 'text-blue' AS ResponseId;
            END
		END
		IF @Flag='Search'
		BEGIN
		    SELECT @UserId=Id FROM dbo.tblUser WHERE Username=@Username;
			SELECT TOP(5) p.PostId FROM dbo.tblPost p INNER JOIN dbo.tblFollow f ON f.FollowedUser=p.Poster WHERE f.FollowedBy=@UserId AND p.PostParent IS NULL AND @Search IN (SELECT [value] FROM STRING_SPLIT(p.PostKeywords, ',')) ORDER BY p.PostedTime DESC
		END
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK;
            SELECT 102 AS Code, ERROR_MESSAGE() AS Message, '' AS Id;
        END;
    END CATCH;
END;