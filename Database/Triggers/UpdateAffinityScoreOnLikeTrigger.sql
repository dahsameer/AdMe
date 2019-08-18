USE [AdMe]
GO
/****** Object:  Trigger [dbo].[UpdateAffinityScoreOnLikeTrigger]    Script Date: 8/12/2019 9:25:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER   TRIGGER [dbo].[UpdateAffinityScoreOnLikeTrigger]
ON [dbo].[tblLike]
AFTER INSERT
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @PreviousAffinityScore FLOAT, @NewAffinityScore FLOAT, @followid INT, @followedUser INT, @followedBy INT;

	SELECT @followedUser=tp.Poster, @followedBy=ti.LikedBy FROM Inserted ti INNER JOIN dbo.tblPost tp ON tp.PostId = ti.PostId;
	SELECT @followid=FollowId, @PreviousAffinityScore=AffinityScore FROM dbo.tblFollow WHERE FollowedBy=@followedBy AND FollowedUser=@followedUser;
	SET @NewAffinityScore=1/(1+EXP(-(@PreviousAffinityScore+0.10)));
	UPDATE dbo.tblFollow SET AffinityScore=@NewAffinityScore WHERE FollowId=@followid;
END