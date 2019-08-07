CREATE OR ALTER PROCEDURE PostProcedure (
    @Flag NVARCHAR(20) = NULL, 
	@Username NVARCHAR(100) = NULL, 
	@PostContent NVARCHAR(2000) = NULL,
    @PostId NVARCHAR(50) = NULL,
	@ParentPostId NVARCHAR(50) = NULL,
	@AllReplies bit = NULL)
AS
SET NOCOUNT ON;
BEGIN
	DECLARE @UserId INT = NULL;
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
		    INSERT INTO dbo.tblPost (PostId, PostParent, PostContent, Poster, PostedTime)
		    VALUES (@PostId,       -- PostId - varchar(50)
		            @ParentPostId,       -- PostParent - varchar(50)
		            @PostContent,      -- PostContent - nvarchar(2000)
		            @UserId,        -- Poster - int
		            GETDATE() -- PostedTime - datetime
		        )
			SELECT 100 AS ResponseCode, 'Successfully posted' AS ResponseMessage, @PostId AS ResponseId;
		END
		IF @Flag = 'AddReply'
		BEGIN
			SELECT @UserId=Id FROM dbo.tblUser WHERE Username=@Username;
		    INSERT INTO dbo.tblPost (PostId, PostParent, PostContent, Poster, PostedTime)
		    VALUES (@PostId,       -- PostId - varchar(50)
		            @ParentPostId,       -- PostParent - varchar(50)
		            @PostContent,      -- PostContent - nvarchar(2000)
		            @UserId,        -- Poster - int
		            GETDATE() -- PostedTime - datetime
		        )
			SELECT 100 AS ResponseCode, 'Successfully posted' AS ResponseMessage, @PostId AS ResponseId;
		END
		IF @Flag = 'GetPost'
		BEGIN
		    SELECT tp.PostId
			FROM dbo.tblPost tp 
			INNER JOIN dbo.tblUser tu ON tu.Id = tp.Poster
			WHERE tp.PostParent IS NULL
		END
		IF @Flag = 'GetPostById'
		BEGIN
		    SELECT tp.PostId, tp.PostContent, tu.Username, tu.Fullname, tp.PostedTime 
			FROM dbo.tblPost tp 
			INNER JOIN dbo.tblUser tu ON tu.Id = tp.Poster 
			WHERE tp.PostId=@PostId
			ORDER BY tp.PostedTime
		END
		IF @Flag = 'GetRepliesForPost'
		BEGIN
			IF @AllReplies = 1
			BEGIN
				SELECT tp.PostId, tp.PostContent, tu.Username, tu.Fullname, tp.PostedTime 
				FROM dbo.tblPost tp 
				INNER JOIN dbo.tblUser tu ON tu.Id = tp.Poster 
				WHERE tp.PostParent=@PostId
				ORDER BY tp.PostedTime
			END
			ELSE
            BEGIN
                SELECT TOP(2) tp.PostId, tp.PostContent, tu.Username, tu.Fullname, tp.PostedTime 
				FROM dbo.tblPost tp 
				INNER JOIN dbo.tblUser tu ON tu.Id = tp.Poster 
				WHERE tp.PostParent=@PostId
				ORDER BY tp.PostedTime
            END
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