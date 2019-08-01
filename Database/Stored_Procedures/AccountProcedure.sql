

CREATE OR ALTER PROCEDURE AccountProcedure
( 
						  @Flag         nvarchar(20)  = NULL, 
						  @Username     nvarchar(50)  = NULL, 
						  @Fullname     nvarchar(100) = NULL, 
						  @Email        nvarchar(100) = NULL, 
						  @Gender       nvarchar(10)  = NULL, 
						  @DateOfBirth  date          = NULL, 
						  @JoinedDate   date          = NULL, 
						  @PasswordHash nvarchar(200) = NULL, 
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
			INSERT INTO dbo.tblUser( Username, Fullname, Email, Gender, DateOfBirth, JoinedDate, PasswordHash )
			VALUES( @Username, @Fullname, @Email, @Gender, @DateOfBirth, GETDATE(), @PasswordHash );
			SELECT 100 AS Code, 'Register Successfull' AS [Message], '' AS Id;
		END;
		IF @flag = 'CheckUser'
		BEGIN
			IF EXISTS
			(
				SELECT 'a'
				FROM dbo.tblUser
				WHERE Username = @Username OR 
					  Email = @Email
			)
			BEGIN
				IF EXISTS
				(
					SELECT 'a'
					FROM dbo.tblUser
					WHERE( Username = @Username OR 
						   Email = @Email
						 ) AND 
						 PasswordHash = @PasswordHash
				)
				BEGIN
					SELECT 100 AS Code, 'Login Successfull' AS [Message], '' AS Id;
				END;
				ELSE
				BEGIN
					SELECT 101 AS Code, 'Password did not match' AS [Message], '' AS Id;
				END;
			END;
			ELSE
			BEGIN
				SELECT 101 AS Code, 'Account not found' AS [Message], '' AS Id;
			END;
		END;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
		BEGIN
			ROLLBACK;
			SELECT 102 AS Code, ERROR_MESSAGE() AS Message, '' AS Id;
		END;
	END CATCH;
END;