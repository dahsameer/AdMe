USE [master]
GO
/****** Object:  Database [AdMe]    Script Date: 8/18/2019 10:00:52 AM ******/
CREATE DATABASE [AdMe]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'AdMe', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\AdMe.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'AdMe_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\AdMe_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [AdMe] SET COMPATIBILITY_LEVEL = 140
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [AdMe].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [AdMe] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [AdMe] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [AdMe] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [AdMe] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [AdMe] SET ARITHABORT OFF 
GO
ALTER DATABASE [AdMe] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [AdMe] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [AdMe] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [AdMe] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [AdMe] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [AdMe] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [AdMe] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [AdMe] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [AdMe] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [AdMe] SET  DISABLE_BROKER 
GO
ALTER DATABASE [AdMe] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [AdMe] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [AdMe] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [AdMe] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [AdMe] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [AdMe] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [AdMe] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [AdMe] SET RECOVERY FULL 
GO
ALTER DATABASE [AdMe] SET  MULTI_USER 
GO
ALTER DATABASE [AdMe] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [AdMe] SET DB_CHAINING OFF 
GO
ALTER DATABASE [AdMe] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [AdMe] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [AdMe] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'AdMe', N'ON'
GO
ALTER DATABASE [AdMe] SET QUERY_STORE = OFF
GO
USE [AdMe]
GO
/****** Object:  Table [dbo].[tblFollow]    Script Date: 8/18/2019 10:00:53 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblFollow](
	[FollowId] [int] IDENTITY(1,1) NOT NULL,
	[FollowedUser] [int] NULL,
	[FollowedBy] [int] NULL,
	[FollowedDate] [datetime] NULL,
	[AffinityScore] [float] NULL,
 CONSTRAINT [PK_tblFollow] PRIMARY KEY CLUSTERED 
(
	[FollowId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblLike]    Script Date: 8/18/2019 10:00:53 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblLike](
	[LikeId] [int] IDENTITY(1,1) NOT NULL,
	[PostId] [nvarchar](50) NULL,
	[LikedBy] [int] NULL,
	[LikedTime] [datetime] NULL,
 CONSTRAINT [PK_tblLike] PRIMARY KEY CLUSTERED 
(
	[LikeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblPost]    Script Date: 8/18/2019 10:00:53 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblPost](
	[PostId] [varchar](50) NOT NULL,
	[PostParent] [varchar](50) NULL,
	[PostContent] [nvarchar](2000) NULL,
	[Poster] [int] NULL,
	[PostedTime] [datetime] NULL,
	[PostKeywords] [nvarchar](500) NULL,
 CONSTRAINT [PK_tblPost] PRIMARY KEY CLUSTERED 
(
	[PostId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblUser]    Script Date: 8/18/2019 10:00:53 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblUser](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Username] [nvarchar](50) NULL,
	[Fullname] [nvarchar](100) NULL,
	[Email] [nvarchar](100) NULL,
	[Gender] [nvarchar](30) NULL,
	[DateOfBirth] [date] NULL,
	[JoinedDate] [date] NULL,
	[Password] [nvarchar](150) NULL,
	[About] [nvarchar](250) NULL,
	[City] [nvarchar](50) NULL,
	[Country] [nvarchar](50) NULL,
	[Photo] [nvarchar](100) NULL,
 CONSTRAINT [PK_tblUser] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblUser] ADD  DEFAULT ('/AppData/default.jpg') FOR [Photo]
GO
ALTER TABLE [dbo].[tblFollow]  WITH CHECK ADD  CONSTRAINT [FK_tblFollow_tblUser] FOREIGN KEY([FollowedBy])
REFERENCES [dbo].[tblUser] ([Id])
GO
ALTER TABLE [dbo].[tblFollow] CHECK CONSTRAINT [FK_tblFollow_tblUser]
GO
ALTER TABLE [dbo].[tblFollow]  WITH CHECK ADD  CONSTRAINT [FK_tblFollow_tblUser1] FOREIGN KEY([FollowedUser])
REFERENCES [dbo].[tblUser] ([Id])
GO
ALTER TABLE [dbo].[tblFollow] CHECK CONSTRAINT [FK_tblFollow_tblUser1]
GO
ALTER TABLE [dbo].[tblPost]  WITH CHECK ADD  CONSTRAINT [FK_tblPost_tblUser] FOREIGN KEY([Poster])
REFERENCES [dbo].[tblUser] ([Id])
GO
ALTER TABLE [dbo].[tblPost] CHECK CONSTRAINT [FK_tblPost_tblUser]
GO
/****** Object:  StoredProcedure [dbo].[AccountProcedure]    Script Date: 8/18/2019 10:00:53 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE   PROCEDURE [dbo].[AccountProcedure]
( 
						  @Flag         nvarchar(50)  = NULL, 
						  @Username     nvarchar(50)  = NULL, 
						  @Fullname     nvarchar(100) = NULL, 
						  @Email        nvarchar(100) = NULL, 
						  @Gender       nvarchar(10)  = NULL, 
						  @DateOfBirth  date          = NULL,
						  @Password     nvarchar(200) = NULL, 
						  @About        nvarchar(250) = NULL, 
						  @City         nvarchar(100) = NULL, 
						  @Country      nvarchar(100) = NULL, 
						  @Photo        nvarchar(100) = NULL,
						  @UserId1		INT			  = NULL,
						  @UserId2		INT			  = NULL,
						  @Search		NVARCHAR(50)  = NULL
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
		    SELECT u2.Username, u2.Fullname, u2.Email, u2.Photo FROM dbo.tblFollow f INNER JOIN dbo.tblUser u1 ON f.FollowedUser=u1.Id INNER JOIN dbo.tblUser u2 ON f.FollowedBy=u2.Id WHERE u1.Id=@UserId1
		END
		IF @Flag='GetFollowings'
		BEGIN
		    SELECT u1.Username, u1.Fullname, u1.Email, u1.Photo FROM dbo.tblFollow f INNER JOIN dbo.tblUser u1 ON f.FollowedUser=u1.Id INNER JOIN dbo.tblUser u2 ON f.FollowedBy=u2.Id WHERE u2.Id=@UserId1
		END
		IF @Flag='UpdateUser'
		BEGIN
		    UPDATE dbo.tblUser SET Fullname = ISNULL(@Fullname, Fullname),
								   Email = ISNULL(@Email, Email),
								   Gender = ISNULL(@Gender, Gender),
								   City = ISNULL(@City, City),
								   Country = ISNULL(@Country, Country),
								   Photo = ISNULL(@Photo, Photo),
								   About = ISNULL(@About, About)
			WHERE Username=@Username
			SELECT 100 AS ResponseCode, 'Successfully Updated profile' AS ResponseMessage, '' AS ResponseId;
		END
		IF @Flag='Search'
		BEGIN
		    SELECT TOP(5) Username FROM dbo.tblUser WHERE LOWER(Fullname) LIKE '%'+@Search+'%' ORDER BY Fullname DESC
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
GO
/****** Object:  StoredProcedure [dbo].[PostProcedure]    Script Date: 8/18/2019 10:00:53 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[PostProcedure] (
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
GO
/****** Object:  StoredProcedure [dbo].[WeeklyDecreaseAffinityScore]    Script Date: 8/18/2019 10:00:53 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[WeeklyDecreaseAffinityScore]
AS
    UPDATE dbo.tblFollow SET AffinityScore=(AffinityScore*0.9);
GO
USE [master]
GO
ALTER DATABASE [AdMe] SET  READ_WRITE 
GO
