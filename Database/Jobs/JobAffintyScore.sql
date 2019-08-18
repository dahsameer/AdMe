DECLARE @job_name NVARCHAR(128), @description NVARCHAR(512), @owner_login_name NVARCHAR(128), @database_name NVARCHAR(128);

SET @job_name = N'Weekly decrease affinity score';
SET @description = N'this will decrease affinity score weekly';
SET @owner_login_name = N'sa';
SET @database_name = N'Netspur';

-- Delete job if it already exists:
IF EXISTS(SELECT job_id FROM msdb.dbo.sysjobs WHERE (name = @job_name))
BEGIN
    EXEC msdb.dbo.sp_delete_job
        @job_name = @job_name;
END

-- Create the job:
EXEC  msdb.dbo.sp_add_job
    @job_name=@job_name, 
    @enabled=1, 
    @notify_level_eventlog=0, 
    @notify_level_email=2, 
    @notify_level_netsend=2, 
    @notify_level_page=2, 
    @delete_level=0, 
    @description=@description, 
    @category_name=N'[Uncategorized (Local)]', 
    @owner_login_name=@owner_login_name;

-- Add server:
EXEC msdb.dbo.sp_add_jobserver @job_name=@job_name;

-- Add step to execute SQL:
EXEC msdb.dbo.sp_add_jobstep
    @job_name=@job_name,
    @step_name=N'Execute SQL', 
    @step_id=1, 
    @cmdexec_success_code=0, 
    @on_success_action=1, 
    @on_fail_action=2, 
    @retry_attempts=0, 
    @retry_interval=0, 
    @os_run_priority=0, 
    @subsystem=N'TSQL', 
    @command=N'EXEC WeeklyDecreaseAffinityScore', 
    @database_name=@database_name, 
    @flags=0;

-- Update job to set start step:
EXEC msdb.dbo.sp_update_job
    @job_name=@job_name, 
    @enabled=1, 
    @start_step_id=1, 
    @notify_level_eventlog=0, 
    @notify_level_email=2, 
    @notify_level_netsend=2, 
    @notify_level_page=2, 
    @delete_level=0, 
    @description=@description, 
    @category_name=N'[Uncategorized (Local)]', 
    @owner_login_name=@owner_login_name, 
    @notify_email_operator_name=N'', 
    @notify_netsend_operator_name=N'', 
    @notify_page_operator_name=N'';

-- Schedule job:
EXEC msdb.dbo.sp_add_jobschedule
    @job_name=@job_name,
    @name=N'Daily',
    @enabled=1,
    @freq_type=8, --specifies weekly
    @freq_interval=1, 
    @freq_subday_type=1, 
    @freq_subday_interval=0, 
    @freq_relative_interval=0, 
    @freq_recurrence_factor=1, 
    @active_start_date=20190630, --YYYYMMDD
    @active_end_date=99991231, --YYYYMMDD (this represents no end date)
    @active_start_time=010000, --HHMMSS
    @active_end_time=235959; --HHMMSS