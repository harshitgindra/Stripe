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
    Login_login_ID int  NOT NULL ,
    CONSTRAINT User_Profile_pk PRIMARY KEY  (userProfile_ID),
	CONSTRAINT User_Profile_Login_FK 
    FOREIGN KEY (Login_login_ID)
    REFERENCES Login (login_ID)
)
;




CREATE TABLE User_Profile_Referee (
    ref_Game_Specialization_Type int  NOT NULL ,
    User_Profile_userProfile_ID int  NOT NULL UNIQUE,
    Sport_Name_spt_Sport_Name_ID int  NOT NULL ,
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

