CREATE OR ALTER PROCEDURE WeeklyDecreaseAffinityScore
AS
    UPDATE dbo.tblFollow SET AffinityScore=(AffinityScore*0.9);
GO