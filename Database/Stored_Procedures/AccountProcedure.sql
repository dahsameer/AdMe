

CREATE OR ALTER PROCEDURE AccountProcedure
( 
						  @Flag         nvarchar(50)  = NULL, 
						  @Username     nvarchar(50)  = NULL, 
						  @Fullname     nvarchar(100) = NULL, 
						  @Email        nvarchar(100) = NULL, 
						  @Gender       nvarchar(10)  = NULL, 
						  @DateOfBirth  date          = NULL, 
						  @JoinedDate   date          = NULL, 
						  @Password     nvarchar(200) = NULL, 
						  @About        nvarchar(250) = NULL, 
						  @City         nvarchar(100) = NULL, 
						  @Country      nvarchar(100) = NULL, 
						  @Photo        nvarchar(100) = NULL,
						  @UserId1		INT			  = NULL,
						  @UserId2		INT			  = NULL
)
AS
	SET NOCOUNT ON;
BEGIN
	BEGIN TRY
		-------------------------------------Add User Block----------------------------
		IF @flag = 'AddUser'
		BEGIN
			IF EXISTS (SELECT 'A' FROM dbo.tblUser WHERE Username=@Username)
			BEGIN
			    SELECT 101 AS ResponseCode, 'Username Already taken' AS ResponseMessage, '' AS ResponseId;
			END
			IF EXISTS (SELECT 'A' FROM dbo.tblUser WHERE Email=@Email)
			BEGIN
			    SELECT 101 AS ResponseCode, 'Email already registered' AS ResponseMessage, '' AS ResponseId;
			END
			ELSE
			BEGIN
			    INSERT INTO dbo.tblUser( Username, Fullname, Email, Gender, DateOfBirth, JoinedDate, [Password] )
				VALUES( @Username, @Fullname, @Email, @Gender, @DateOfBirth, GETDATE(), @Password );
				SELECT 100 AS ResponseCode, 'Register Successfull' AS ResponseMessage, '' AS ResponseId; 
			END
		END;
		IF @flag = 'CheckUser'
		BEGIN
			IF EXISTS (SELECT 'a' FROM dbo.tblUser WHERE Username = @Username)
			BEGIN
				IF EXISTS (SELECT 'a' FROM dbo.tblUser WHERE Username = @Username AND [Password] = @Password)
				BEGIN
					SELECT 100 AS ResponseCode, 'Login Successfull' AS ResponseMessage, '' AS ResponseId;
				END;
				ELSE
				BEGIN
					SELECT 101 AS ResponseCode, 'Password did not match' AS ResponseMessage, '' AS ResponseId;
				END;
			END;
			ELSE
			BEGIN
				SELECT 101 AS ResponseCode, 'Account not found' AS ResponseMessage, '' AS ResponseId;
			END;
		END;
		IF @Flag = 'GetUserProfile'
		BEGIN
			IF EXISTS (SELECT 'A' FROM dbo.tblUser WHERE Username = @Username)
			BEGIN
			    SELECT Id, Username, Fullname, Email, Gender, DateOfBirth, JoinedDate, [Password], About, City, Country, Photo FROM dbo.tblUser WHERE Username=@Username
			END
		END
		IF @Flag='GetFollowButtonText'
		BEGIN
		    SELECT @UserId1=Id FROM dbo.tblUser WHERE Username=@Username
			IF @UserId1=@UserId2
			BEGIN
			    SELECT 100 AS ResponseCode, 'Edit' AS ResponseMessage, '' AS ResponseId;
				RETURN
			END
			IF EXISTS(SELECT 'A' FROM dbo.tblFollow WHERE FollowedUser=@UserId2 AND FollowedBy=@UserId1)
			BEGIN
			    SELECT 100 AS ResponseCode, 'Unfollow' AS ResponseMessage, '' AS ResponseId;
				RETURN
			END
			ELSE
            BEGIN
                SELECT 100 AS ResponseCode, 'Follow' AS ResponseMessage, '' AS ResponseId;
				RETURN
            END
		END
		IF @Flag='ToggleFollow'
		BEGIN
		    SELECT @UserId1=Id FROM dbo.tblUser WHERE Username=@Username
			IF @UserId1=@UserId2
			BEGIN
			    SELECT 101 AS ResponseCode, 'Cannot follow yourself' AS ResponseMessage, '' AS ResponseId;
			END
			IF EXISTS(SELECT 'a' FROM dbo.tblFollow WHERE FollowedUser=@UserId2 AND FollowedBy=@UserId1)
			BEGIN
			    DELETE FROM dbo.tblFollow WHERE FollowedUser=@UserId2 AND FollowedBy=@UserId1
				SELECT 100 AS ResponseCode, 'Follow' AS ResponseMessage, '' AS ResponseId;
			END
			ELSE
			BEGIN
			    INSERT INTO dbo.tblFollow (FollowedUser, FollowedBy, FollowedDate, AffinityScore)
			    VALUES (@UserId2, @UserId1, GETDATE(), 0.5)
				SELECT 100 AS ResponseCode, 'Unfollow' AS ResponseMessage, '' AS ResponseId;
			END
		END
		IF @Flag='GetFollowers'
		BEGIN
		    SELECT u2.Username, u2.Fullname, u2.Email FROM dbo.tblFollow f INNER JOIN dbo.tblUser u1 ON f.FollowedUser=u1.Id INNER JOIN dbo.tblUser u2 ON f.FollowedBy=u2.Id WHERE u1.Id=@UserId1
		END
		IF @Flag='GetFollowings'
		BEGIN
		    SELECT u1.Username, u1.Fullname, u1.Email FROM dbo.tblFollow f INNER JOIN dbo.tblUser u1 ON f.FollowedUser=u1.Id INNER JOIN dbo.tblUser u2 ON f.FollowedBy=u2.Id WHERE u2.Id=@UserId1
		END
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
		BEGIN
			ROLLBACK;
			SELECT 102 AS ResponseCode, ERROR_MESSAGE() AS ResponseMessage, '' AS ResponseId;
		END;
	END CATCH;
END;