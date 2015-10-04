DROP TABLE Referee_Event_History;
DROP TABLE Sport_Event;
DROP TABLE Sport_Type_Referees;
DROP TABLE School;
DROP TABLE User_Profile_Referee;
DROP TABLE User_Profile;
DROP TABLE Login;
DROP TABLE Referee_Status;
DROP TABLE Sport_Name;
DROP TABLE User_Type;

CREATE TABLE User_Type (
    userType_ID nchar(1)  NOT NULL ,
    userType_Name nvarchar(25)  NOT NULL ,
    CONSTRAINT User_Type_pk PRIMARY KEY  (userType_ID)
)
;


CREATE TABLE Sport_Name (
    spt_Sport_Name_ID int identity(1,1),
    spt_Name nvarchar(50)  NOT NULL ,
    CONSTRAINT Sport_Name_pk PRIMARY KEY  (spt_Sport_Name_ID)
)
;

CREATE TABLE Referee_Status (
    refStatus_ID nchar(1)  NOT NULL ,
    refStatus_Description nvarchar(25)  NOT NULL ,
    CONSTRAINT Referee_Status_pk PRIMARY KEY  (refStatus_ID)
)
;



CREATE TABLE Login (
    login_ID int IDENTITY(1,1)  NOT NULL ,
    login_username nvarchar(20)  NOT NULL ,
    login_password nvarchar(20)  NOT NULL ,
    login_random_string nvarchar(45)  NULL ,
    login_approvalStatus bit  NOT NULL ,
    User_Type_userType_ID nchar(1)  NOT NULL ,
    CONSTRAINT Login_pk PRIMARY KEY  (login_ID), 
	CONSTRAINT Login_User_Type_FK 
    FOREIGN KEY (User_Type_userType_ID)
    REFERENCES User_Type (userType_ID)
)
;

CREATE TABLE User_Profile (
    userProfile_ID int,
    userProfile_First_Name nvarchar(100)  NOT NULL ,
    userProfile_Last_Name nvarchar(100)  NOT NULL ,
    userProfile_Email nvarchar(150)  NOT NULL ,
    userProfile_Phone nvarchar(10)  NOT NULL ,
    userProfile_Street nvarchar(200)  NULL ,
    userProfile_City nvarchar(150)  NULL ,
    userProfile_State nvarchar(150)  NULL ,
    userProfile_Zip nvarchar(10)  NULL ,
    userProfile_Photo nvarchar(max)  NULL ,
    userProfile_Background_Description nvarchar(max)  NULL ,
	userProfile_Lat decimal(11,8) null,
	userProfile_Long decimal(11,8) null,
    Login_login_ID int  NOT NULL ,
    CONSTRAINT User_Profile_pk PRIMARY KEY  (userProfile_ID),
	CONSTRAINT User_Profile_Login_FK 
    FOREIGN KEY (Login_login_ID)
    REFERENCES Login (login_ID)
)
;

----------------------------------------------------------------------
CREATE TABLE User_Profile_Referee (
    ref_Game_Specialization_Type int  NOT NULL ,
    User_Profile_userProfile_ID int  NOT NULL UNIQUE,
    Sport_Name_spt_Sport_Name_ID int  NOT NULL ,
	User_Profile_Referee_Total_Ratings int,
	User_Profile_Referee_Games_Officiated int,
	CONSTRAINT User_Profile_Referee_User_Profile 
    FOREIGN KEY (User_Profile_userProfile_ID)
    REFERENCES User_Profile (userProfile_ID), 
	CONSTRAINT User_Profile_Sport_Name_FK 
	FOREIGN KEY (Sport_Name_spt_Sport_Name_ID)
	REFERENCES Sport_Name(spt_Sport_Name_ID)
)
;

CREATE TABLE School (
    sch_ID int  NOT NULL IDENTITY(1,1) ,
    sch_Name nvarchar(200)  NOT NULL ,
    sch_Street nvarchar(max)  NULL ,
    sch_City nvarchar(50)  NULL ,
    sch_State nvarchar(50)  NULL ,
    sch_Zip nvarchar(10)  NULL ,
    sch_Logo nvarchar(max)  NULL ,
    User_Profile_Director_Profile_ID int  NOT NULL ,
    CONSTRAINT School_pk PRIMARY KEY  (sch_ID),
	CONSTRAINT User_Profile_Director_Profile_ID_FK 
	FOREIGN KEY (User_Profile_Director_Profile_ID)
	REFERENCES USER_PROFILE(userProfile_ID)
)
;

-- Table: Sport_Type_Referees
CREATE TABLE Sport_Type_Referees (
    sptTypeRef_ID int  NOT NULL IDENTITY(1,1) ,
    sptTypeRef_Referee_Title nvarchar(50)  NOT NULL ,
    Sport_Name_spt_Sport_Name_ID int  NOT NULL ,
    CONSTRAINT Sport_Type_Referees_pk PRIMARY KEY  (sptTypeRef_ID),
	CONSTRAINT Sport_Type_Referee_Sport_Name_FK
	FOREIGN KEY (Sport_Name_spt_Sport_Name_ID)
	REFERENCES Sport_Name(spt_Sport_Name_ID)

)
;


-- Table: Sport_Event
CREATE TABLE Sport_Event (
    event_ID int  NOT NULL identity(1,1),
    event_Completion nchar(1)  NULL ,
    event_Date date  NOT NULL ,
    event_Time time(0)  NOT NULL ,
    event_Home_Team_Score int  NULL ,
    event_Away_Team_Score int  NULL ,
    event_School_Field_Name nvarchar(200)  NOT NULL ,
    School_Home_sch_ID int  NOT NULL ,
    School_Away_sch_ID int  NOT NULL ,
    Sport_Name_spt_Sport_Name_ID int  NOT NULL ,
    CONSTRAINT Sport_Event_pk PRIMARY KEY  (event_ID),
	CONSTRAINT Sport_Event_Home_School_ID_FK 
    FOREIGN KEY (School_Home_sch_ID)
    REFERENCES School (sch_ID),

	CONSTRAINT Sport_Event_Away_School_ID_FK 
    FOREIGN KEY (School_Away_sch_ID)
    REFERENCES School (sch_ID),
	CONSTRAINT Sport_Event_Sport_Name_FK 
    FOREIGN KEY (Sport_Name_spt_Sport_Name_ID)
    REFERENCES Sport_Name (spt_Sport_Name_ID)
)
;


-- Table: Referee_Event_History
CREATE TABLE Referee_Event_History (
    refEventHistory_ID int  NOT NULL IDENTITY(1,1) ,
    refEventHistory_Total_Stars_Rating int  NULL ,
    Sport_Event_event_ID int  NOT NULL ,
    User_Profile_Referee_Profile_ID int  NOT NULL ,
    User_Profile_School_Director_Profile_ID int  NOT NULL ,
    Referee_Status_refStatus_ID nchar(1)  NOT NULL ,
    Sport_Type_Referees_sptTypeRef_ID int  NOT NULL ,
    CONSTRAINT Referee_Event_History_pk PRIMARY KEY  (refEventHistory_ID),
	CONSTRAINT Referee_Event_History_Referee_Status_FK 
    FOREIGN KEY (Referee_Status_refStatus_ID)
    REFERENCES Referee_Status (refStatus_ID),

	CONSTRAINT Referee_Event_History_Sport_Type_Referees_FK 
    FOREIGN KEY (Sport_Type_Referees_sptTypeRef_ID)
    REFERENCES Sport_Type_Referees (sptTypeRef_ID),

	CONSTRAINT Referee_Event_History_Sport_Event_FK 
    FOREIGN KEY (Sport_Event_event_ID)
    REFERENCES Sport_Event (event_ID),

	CONSTRAINT Referee_Event_History_Referee_Profile_FK 
    FOREIGN KEY (User_Profile_Referee_Profile_ID)
    REFERENCES User_Profile (userProfile_ID),

	CONSTRAINT Referee_Event_History_School_Director_Profile_FK 
    FOREIGN KEY (User_Profile_School_Director_Profile_ID)
    REFERENCES User_Profile (userProfile_ID)
);


INSERT INTO User_Type
VALUES ('R', 'REFEREE');
INSERT INTO User_Type
VALUES ('S', 'SCHOOL REPRESENTATIVE');
INSERT INTO User_Type
VALUES ('A', 'ADMIN');

INSERT INTO Referee_Status
VALUES('P' , 'PENDING');
INSERT INTO Referee_Status
VALUES('A' , 'APPROVED');
INSERT INTO Referee_Status
VALUES('S' , 'SUBSTITUTE');
INSERT INTO Referee_Status
VALUES('D' , 'DENIED');

INSERT INTO Sport_Name
VALUES ('SOCCER');
INSERT INTO Sport_Name
VALUES ('FOOTBALL');
INSERT INTO Sport_Name
VALUES ('FIELD HOCKEY');
INSERT INTO Sport_Name
VALUES ('BASKETBALL');

INSERT INTO Sport_Type_Referees
  VALUES('LINESMAN-1',1)
   INSERT INTO Sport_Type_Referees
  VALUES('LINESMAN-1',1)
   INSERT INTO Sport_Type_Referees
  VALUES('MATCH REFEREE',1)

   INSERT INTO Sport_Type_Referees
  VALUES('REFEREE',2)
   INSERT INTO Sport_Type_Referees
  VALUES('UMPIRE',2)
   INSERT INTO Sport_Type_Referees
  VALUES('HEAD LINESMAN',2)
   INSERT INTO Sport_Type_Referees
  VALUES('LINE JUDGE',2)
   INSERT INTO Sport_Type_Referees
  VALUES('FIELD JUDGE',2)
    INSERT INTO Sport_Type_Referees
  VALUES('SIDE JUDGE',2)
   INSERT INTO Sport_Type_Referees
  VALUES('BACK JUDGE',2)

    INSERT INTO Sport_Type_Referees
  VALUES('UMPIRE-1',3)
    INSERT INTO Sport_Type_Referees
  VALUES('UMPIRE-2',3)


    INSERT INTO Sport_Type_Referees
  VALUES('LEAD UMPIRE',4)  
    INSERT INTO Sport_Type_Referees
  VALUES('REFEREE-1',4)
      INSERT INTO Sport_Type_Referees
  VALUES('REFEREE-2',4)

    INSERT INTO Login
  VALUES('ABE','123',NULL,0,'S')

    INSERT INTO Login
  VALUES('FRANK','123',NULL,0,'S')

    INSERT INTO Login
  VALUES('hgindra','123',NULL,0,'R')

  -----------------------------------------------------------
  CREATE PROC SP_USER_PROFILE_INSERT
@userid int,
@firstName nvarchar(100),
@lastName nvarchar(100),
@email nvarchar(100),
@phone nvarchar(100),
@street nvarchar(200),
@city nvarchar(100),
@state nvarchar(100),
@zip nvarchar(100),
@photo nvarchar(max),
@backgroud_desc nvarchar(max),
@loginid int
as
begin
INSERT INTO DBO.User_Profile
VALUES(@userid, @firstName, @lastName, @email, @phone, @street, @city, @state, @zip, @photo, @backgroud_desc, @loginid)
end;
   
----------------------------------------------------------------------
CREATE PROC SP_USER_PROFILE_REFEREE_INSERT
@gameReferee int,
@loginid int,
@gameId int
as
begin
INSERT INTO DBO.User_Profile_Referee
VALUES(@gameReferee, @loginid, @gameId)
end;
   

   ------------------------------------------------------------------------

   CREATE PROC SP_USER_PROFILE_GET
@loginid int
as
begin
SELECT * FROM User_Profile A
JOIN User_Profile_Referee B ON A.userProfile_ID = B.User_Profile_userProfile_ID
WHERE A.userProfile_ID = @loginid
end;
   
   --------------------------------------------------------
     CREATE PROC SP_USER_PROFILE_UPDATE
@userid int,
@firstName nvarchar(100),
@lastName nvarchar(100),
@email nvarchar(100),
@phone nvarchar(100),
@street nvarchar(200),
@city nvarchar(100),
@state nvarchar(100),
@zip nvarchar(100),
@photo nvarchar(max),
@backgroud_desc nvarchar(max)
as
begin
UPDATE User_Profile
SET userProfile_First_Name = @firstName,
userProfile_Last_Name = @lastName,
userProfile_Email = @email,
userProfile_Phone = @phone,
userProfile_Street = @street,
userProfile_City = @city,
userProfile_State = @state,
userProfile_Zip = @zip,
userProfile_Photo = @photo,
userProfile_Background_Description = @backgroud_desc
WHERE userProfile_ID = @userid
end;


-----------------------------------------------------------------------
CREATE PROC SP_USER_PROFILE_REFEREE_UPDATE
@gameReferee int,
@loginid int,
@gameId int
as
begin
UPDATE User_Profile_Referee
SET ref_Game_Specialization_Type = @gameReferee,
Sport_Name_spt_Sport_Name_ID = @gameId
WHERE User_Profile_userProfile_ID = @loginid
end;

-------------------------------------------------------------------------
CREATE PROC SP_LOGIN
@username nvarchar(20),
@password nvarchar(20)
as
begin
SELECT * FROM Login
WHERE [login_username] = @username and  [login_password] = @password
end;
------------------------------------------------------------------------
CREATE PROC SP_SCHOOL_DETAILS_FROM_DIRECTOR
@directorId int
as
begin
SELECT * FROM School
WHERE User_Profile_Director_Profile_ID = @directorId
END;

--------------------------------------------------------------------------

CREATE PROC SP_GET_ALL_SCHOOL_DETAILS
as
begin
SELECT * FROM School
END;

------------------------------------------------------------------------
CREATE PROC SP_SCHOOL_DETAILS_UPDATE
@schName nvarchar(200),
@schStreet nvarchar(max),
@schCity nvarchar(50),
@schState nvarchar(50),
@schZip nvarchar(10),
@schLogo nvarchar(max),
@directorId int
as
begin
UPDATE School
SET sch_Name = @schName,
sch_Street = @schStreet,
sch_City = @schCity,
sch_State = @schState,
@schZip = @schZip,
@schLogo = @schLogo
where User_Profile_Director_Profile_ID = @directorId
END;

------------------------------------------------------------------------
CREATE PROC SP_SCHOOL_DETAILS_INSERT
@schName nvarchar(200),
@schStreet nvarchar(max),
@schCity nvarchar(50),
@schState nvarchar(50),
@schZip nvarchar(10),
@schLogo nvarchar(max),
@directorId int
as
begin
INSERT INTO School
VALUES(
@schName,
@schStreet,
@schCity,
@schState,
@schZip,
@schLogo,
@directorId
)
END;

--------------------------------------------------------------------------
CREATE PROC SP_GET_EVENT_BY_EVENTID
@eventId INT
AS
BEGIN
SELECT A.event_ID, 
A.event_Date, 
A.event_Time,
A.event_School_Field_Name,
A.event_Home_Team_Score, 
A.event_Away_Team_Score, 
A.event_Completion,
a.Sport_Name_spt_Sport_Name_ID,
B.spt_Name,
a.School_Away_sch_ID,
a.School_Home_sch_ID,
C.sch_Name as HomeTeamName,
D.sch_Name as AwayTeamName
FROM Sport_Event A
JOIN Sport_Name B ON A.Sport_Name_spt_Sport_Name_ID = B.spt_Sport_Name_ID
JOIN School C ON A.School_Home_sch_ID = C.sch_ID
JOIN School D ON A.School_Away_sch_ID = D.sch_ID
WHERE A.event_ID =@eventId
END

--------------------------------------------------------------------------
CREATE PROC SP_EVENT_DETAILS_UPDATE
@eventDate date,
@eventTime time,
@eventFieldName nvarchar(100),
@sportId int,
@eventId int
AS
BEGIN
UPDATE Sport_Event
SET event_Date = @eventDate,
event_Time = @eventTime,
event_School_Field_Name = @eventFieldName,
Sport_Name_spt_Sport_Name_ID = @sportId
where event_ID = @eventId
END

------------------------------------------------------------------------

CREATE PROC SP_EVENT_DETAILS_DELETE
@eventId int
AS
BEGIN
DELETE FROM Sport_Event
WHERE event_ID = @eventId
END

---------------------------------------------------------------------------

CREATE PROC SP_GET_EVENT_BY_SCHOOLID
@schId int
AS
BEGIN
SELECT A.event_ID, 
A.event_Date, 
A.event_Home_Team_Score, 
A.event_Away_Team_Score, 
A.event_Completion,
a.Sport_Name_spt_Sport_Name_ID,
B.spt_Name,
C.sch_Name as HomeTeamName,
D.sch_Name as AwayTeamName,
A.School_Home_sch_ID,
a.School_Away_sch_ID
FROM Sport_Event A
JOIN Sport_Name B ON A.Sport_Name_spt_Sport_Name_ID = B.spt_Sport_Name_ID
JOIN School C ON A.School_Home_sch_ID = C.sch_ID
JOIN School D ON A.School_Away_sch_ID = D.sch_ID
WHERE A.School_Home_sch_ID = @schId
END

--------------------------------------------------------------------------

CREATE PROC SP_GET_ALL_EVENTS
@eventCompletion nchar(1)
AS
BEGIN
SELECT A.event_ID, 
A.event_Date, 
A.event_Time,
A.event_School_Field_Name,
A.event_Home_Team_Score, 
A.event_Away_Team_Score, 
A.event_Completion,
B.spt_Name,
a.Sport_Name_spt_Sport_Name_ID,
a.School_Away_sch_ID,
a.School_Home_sch_ID,
C.sch_Name as HomeTeamName,
D.sch_Name as AwayTeamName
FROM Sport_Event A
JOIN Sport_Name B ON A.Sport_Name_spt_Sport_Name_ID = B.spt_Sport_Name_ID
JOIN School C ON A.School_Home_sch_ID = C.sch_ID
JOIN School D ON A.School_Away_sch_ID = D.sch_ID
AND A.event_Completion = @eventCompletion
END

---------------------------------------------------------------------------

CREATE PROC SP_EVENT_SCORES_UPDATE
@homeTeamScore int,
@awayTeamScore int,
@eventCompletion nchar,
@eventId int
AS
BEGIN
UPDATE Sport_Event
SET event_Home_Team_Score = @homeTeamScore,
event_Away_Team_Score = @awayTeamScore,
event_Completion = @eventCompletion
where event_ID = @eventId
END

---------------------------------------------------------------------------
CREATE PROC SP_EVENT_REFEREE_OPENINGS
@eventId int,
@refereeType int
AS
BEGIN
SELECT * FROM Referee_Event_History A
where a.Sport_Event_event_ID = @refereeType
and a.Referee_Status_refStatus_ID = @refereeStatus
END

---------------------------------------------------------------------------

CREATE PROC SP_EVENT_REFEREE_APPLY
@event_ID int,
@refereeId int,
@directorId int,
@refereeStatus nchar,
@refereeType int
AS
BEGIN
INSERT INTO Referee_Event_History(Sport_Event_event_ID, 
User_Profile_Referee_Profile_ID,
User_Profile_School_Director_Profile_ID,
Referee_Status_refStatus_ID,
Sport_Type_Referees_sptTypeRef_ID)
VALUES(@eventId,
@refereeId,
@directorId,
@refereeStatus,
@refereeType)
END

---------------------------------------------------------------------------

CREATE PROC SP_EVENT_REFEREE_APPROVE
@eventId int,
@directorId int,
@refereeStatus nchar,
@refereeType int
AS
BEGIN
UPDATE Referee_Event_History
SET Referee_Status_refStatus_ID = @refereeStatus
where Sport_Event_event_ID = @eventId
and User_Profile_School_Director_Profile_ID = @directorId
and Sport_Type_Referees_sptTypeRef_ID = @refereeType;
END

---------------------------------------------------------------------------

CREATE PROC SP_EVENT_REFEREE_GIVE_RATINGS
@eventId int,
@directorId int,
@ratings int,
@refereeType int
AS
BEGIN
UPDATE Referee_Event_History
SET refEventHistory_Total_Stars_Rating = @ratings
where Sport_Event_event_ID = @eventId
and User_Profile_School_Director_Profile_ID = @directorId
and Sport_Type_Referees_sptTypeRef_ID = @refereeType;
END

---------------------------------------------------------------------------

CREATE PROC SP_EVENT_REFEREE_CHECK_AVAILABILITY
@eventId int,
@refereeStatus nchar(1)
AS
BEGIN
SELECT * FROM Referee_Event_History A
JOIN Sport_Type_Referees B ON A.Sport_Type_Referees_sptTypeRef_ID = B.
END;

---------------------------------------------------------------------------

CREATE PROC SP_EVENT_REFEREE_VERIFY_ELIGIBILITY
@eventId int,
@refereeId int
AS
BEGIN
SELECT * FROM Referee_Event_History
where Sport_Event_event_ID = @eventId
and User_Profile_Referee_Profile_ID = @refereeId

END

-------------------------------------------------------------------------

CREATE PROC SP_GET_DIRECTORID_FROM_SCHOOLID
@schoolId int
AS
BEGIN
SELECT * FROM SCHOOL A
JOIN USER_PROFILE B ON A.[User_Profile_Director_Profile_ID] = B.[userProfile_ID]
WHERE A.[sch_ID] = @schoolId
END

-------------------------------------------------------------------------
CREATE PROC SP_GET_APPLICATION_STATUS_BY_REFEREEID
@refereeId int
AS
BEGIN
SELECT 
B.sptTypeRef_Referee_Title,
C.userProfile_ID, 
C.userProfile_First_Name,
C.userProfile_Last_Name,
C.userProfile_Photo,
D.refStatus_Description,
E.spt_Name,
G.sch_Name AS AwayTeamName,
F.School_Away_sch_ID,
F.School_Home_sch_ID,
H.sch_Name as HomeTeamName
 FROM Referee_Event_History A
JOIN Sport_Type_Referees B ON A.Sport_Type_Referees_sptTypeRef_ID = B.sptTypeRef_ID
JOIN User_Profile C ON A.User_Profile_Referee_Profile_ID = C.userProfile_ID
JOIN Referee_Status D ON A.Referee_Status_refStatus_ID = D.refStatus_ID
JOIN Sport_Name E ON B.Sport_Name_spt_Sport_Name_ID = E.spt_Sport_Name_ID
JOIN Sport_Event F ON A.Sport_Event_event_ID = F.event_ID
JOIN School G ON F.School_Away_sch_ID = G.sch_ID
JOIN School H ON F.School_Home_sch_ID = H.sch_ID
and A.User_Profile_Referee_Profile_ID = @refereeId
AND F.event_Completion = 'N'
END
;

-------------------------------------------------------------------------
CREATE PROC SP_GET_APPLICATION_STATUS_BY_EVENTID
@eventId int
AS
BEGIN
SELECT 
A.Sport_Event_event_ID,
B.sptTypeRef_Referee_Title,
C.userProfile_ID, 
C.userProfile_First_Name,
C.userProfile_Last_Name,
C.userProfile_Photo,
D.refStatus_ID,
D.refStatus_Description,
E.spt_Name,
G.sch_Name AS AwayTeamName,
F.School_Away_sch_ID,
F.School_Home_sch_ID,
H.sch_Name as HomeTeamName
 FROM Referee_Event_History A
JOIN Sport_Type_Referees B ON A.Sport_Type_Referees_sptTypeRef_ID = B.sptTypeRef_ID
JOIN User_Profile C ON A.User_Profile_Referee_Profile_ID = C.userProfile_ID
JOIN Referee_Status D ON A.Referee_Status_refStatus_ID = D.refStatus_ID
JOIN Sport_Name E ON B.Sport_Name_spt_Sport_Name_ID = E.spt_Sport_Name_ID
JOIN Sport_Event F ON A.Sport_Event_event_ID = F.event_ID
JOIN School G ON F.School_Away_sch_ID = G.sch_ID
JOIN School H ON F.School_Home_sch_ID = H.sch_ID
and A.Sport_Event_event_ID = @eventId
AND F.event_Completion = 'N'
ORDER BY A.Sport_Event_event_ID
END
;
-------------------------------------------------------------------------
CREATE PROC SP_UPDATE_REFEREE_STATUS_BY_EVENTID
@eventId int,
@refereeId int,
@refereeStatus nchar
AS
BEGIN
UPDATE Referee_Event_History
SET Referee_Status_refStatus_ID = @refereeStatus
WHERE Sport_Event_event_ID = @eventId
and User_Profile_Referee_Profile_ID = @refereeId
END

-------------------------------------------------------------------------