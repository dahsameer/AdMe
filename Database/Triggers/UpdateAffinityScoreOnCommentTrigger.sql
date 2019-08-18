 USE [AdMe]
GO
/****** Object:  Trigger [dbo].[UpdateAffinityScoreOnCommentTrigger]    Script Date: 8/12/2019 9:25:31 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER   TRIGGER [dbo].[UpdateAffinityScoreOnCommentTrigger]
ON [dbo].[tblPost]
AFTER INSERT
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @PreviousAffinityScore FLOAT, @NewAffinityScore FLOAT, @followid int, @followedUser INT, @followedBy INT, @doAction NVARCHAR(20);
	SELECT @followedUser=tp.Poster, @followedBy=ti.Poster, @doAction=ti.PostParent FROM Inserted ti INNER JOIN dbo.tblPost tp ON tp.PostId = ti.PostId;
	IF @doAction is NOT NULL
    BEGIN
		SELECT @followid=FollowId, @PreviousAffinityScore=AffinityScore FROM dbo.tblFollow WHERE FollowedBy=@followedBy AND FollowedUser=@followedUser;
		SET @NewAffinityScore=1/(1+EXP(-(@PreviousAffinityScore+0.15)));
		UPDATE dbo.tblFollow SET AffinityScore=@NewAffinityScore WHERE FollowId=@followid; 
    END
END