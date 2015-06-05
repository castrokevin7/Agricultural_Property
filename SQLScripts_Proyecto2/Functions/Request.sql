USE [AgriculturalProperty]
GO
--Function for verifing the approval of a certain request
CREATE FUNCTION [dbo].[APFN_ApproveRequestVerify](@oldDescription VARCHAR(200), @RealAmount FLOAT, @RealDescription VARCHAR(50))
RETURNS INT
AS
BEGIN
			BEGIN

				DECLARE @RequestId INT, @RequestAmount FLOAT
				SET @RequestId=(SELECT R.ID  FROM dbo.AP_Request R
											inner join dbo.AP_LotXCycle LC ON R.FK_LotXCycle = LC.ID
											inner join dbo.AP_Cycle C ON C.ID= LC.FK_Cycle
											WHERE R.RequestState ='Pendiente' and  R.RequestDescription=@oldDescription)
						IF(dbo.APFN_ServiceRequestID(@RequestId)<>0)
							BEGIN
								SET @RequestAmount=(SELECT SR.AmountHours  FROM AP_ServiceRequest SR
													WHERE @RequestId = SR.FK_Service)
								IF (@RequestAmount >= @RealAmount)
									BEGIN
										DECLARE @t int;
									END
								ELSE
									RETURN  0
							END
						ELSE IF(dbo.APFN_SupplyRequestID(@RequestId)<>0)
							BEGIN
								SET @RequestAmount=(SELECT SR.Amount  FROM AP_SupplyRequest SR
													WHERE @RequestId = SR.FK_Supply)
								IF (@RequestAmount >= @RealAmount)
									BEGIN
										DECLARE @e int;
									END
								ELSE 
									RETURN 0
							END
						ELSE IF(dbo.APFN_MachineryRequestID(@RequestId)<>0)
							BEGIN
								SET @RequestAmount=(SELECT MR.AmountHours  FROM AP_MachineryRequest MR
													WHERE @RequestId = MR.FK_Machinery)
								IF (@RequestAmount >= @RealAmount)
									BEGIN
										DECLARE @f int
									END
								ELSE 
									RETURN 0
							END
						ELSE
							RETURN 0
				RETURN 1
			END
				RETURN 0
END


--Function for verifing the modification of a certain request
CREATE Function [dbo].[APFN_ModifyValidate](@oldDescription VARCHAR(200), @Description VARCHAR(200), @RequestType VARCHAR(50), @Amount FLOAT)
RETURNS INT
AS
BEGIN
			BEGIN
				IF (@Description <> '')
					BEGIN
						DECLARE @t int;
					END
				IF (@RequestType <> '')
					BEGIN
						IF (dbo.APFN_RequestTypeID(@RequestType)<>0)
							BEGIN
							DECLARE @r int;
							END
					END
				IF (@Amount <> '')
					BEGIN
					DECLARE @RequestId INT
							SET @RequestId=(SELECT R.ID  FROM dbo.AP_Request R
												inner join dbo.AP_LotXCycle LC ON R.FK_LotXCycle = LC.ID
												inner join dbo.AP_Cycle C ON C.ID= LC.FK_Cycle
												WHERE  R.RequestDescription = @oldDescription)
							IF(dbo.APFN_ServiceRequestID(@RequestId)<>0)
								BEGIN
									DECLARE @s int;
								END
							ELSE IF(dbo.APFN_SupplyRequestID(@RequestId)<>0)
								BEGIN
									DECLARE @a int;
								END
							ELSE IF(dbo.APFN_MachineryRequestID(@RequestId)<>0)
								BEGIN
									DECLARE @o int;
								END
							ELSE
								RETURN 0
					END

				RETURN 1
	
			END
				RETURN 0
	
END

GO