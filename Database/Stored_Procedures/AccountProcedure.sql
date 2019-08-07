

CREATE OR ALTER PROCEDURE AccountProcedure
( 
						  @Flag         nvarchar(20)  = NULL, 
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
						  @Photo        nvarchar(100) = NULL
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
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
		BEGIN
			ROLLBACK;
			SELECT 102 AS ResponseCode, ERROR_MESSAGE() AS ResponseMessage, '' AS ResponseId;
		END;
	END CATCH;
END;