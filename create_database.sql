/* ============================
   DATABASE CREATION
   ============================ */
CREATE DATABASE MokeSell;
GO
USE MokeSell;
GO

/* ============================
   CORE LOOKUP TABLES
   ============================ */
CREATE TABLE Award (
    AwardID TINYINT PRIMARY KEY,
    AwardName VARCHAR(50) NOT NULL,
    AwardAmt MONEY CHECK (AwardAmt >= 0) NOT NULL
);

CREATE TABLE Bump (
    BumpID TINYINT PRIMARY KEY,
    BumpDesc VARCHAR(100) NOT NULL,
    BumpPrice MONEY CHECK (BumpPrice >= 0) NOT NULL
);

CREATE TABLE Category (
    CatID INT PRIMARY KEY,
    CatDesc VARCHAR(50) NOT NULL
);

CREATE TABLE FeedbkCat (
    FbkCatID TINYINT PRIMARY KEY,
    FbkCatDesc VARCHAR(50) NOT NULL
);

/* ============================
   MEMBER / USER TABLES
   ============================ */
CREATE TABLE Member (
    MemberID INT PRIMARY KEY,
    MemberName VARCHAR(50) NOT NULL,
    MemberEmail VARCHAR(100) NOT NULL,
    MemberMobile VARCHAR(8),
    MemberDateJoined SMALLDATETIME NOT NULL DEFAULT GETDATE(),
    MemberDOB SMALLDATETIME,
    City VARCHAR(50),
    CHECK (MemberDOB < GETDATE())
);

CREATE TABLE Buyer (
    BuyerID INT PRIMARY KEY,
    CONSTRAINT FK_Buyer_Member
        FOREIGN KEY (BuyerID) REFERENCES Member(MemberID)
);

CREATE TABLE Seller (
    SellerID INT PRIMARY KEY,
    CONSTRAINT FK_Seller_Member
        FOREIGN KEY (SellerID) REFERENCES Member(MemberID)
);

CREATE TABLE Follower (
    MemberID INT NOT NULL,
    FollowerID INT NOT NULL,
    DateStarted SMALLDATETIME NOT NULL,
    CONSTRAINT PK_Follower PRIMARY KEY (MemberID, FollowerID),
    CONSTRAINT FK_Follower_Member
        FOREIGN KEY (MemberID) REFERENCES Member(MemberID),
    CONSTRAINT FK_Follower_Follower
        FOREIGN KEY (FollowerID) REFERENCES Member(MemberID)
);

/* ============================
   TEAM & STAFF TABLES
   ============================ */
CREATE TABLE Team (
    TeamID INT PRIMARY KEY,
    TeamName VARCHAR(100) NOT NULL,
    TeamLeaderID INT NOT NULL
);

CREATE TABLE Staff (
    StaffID INT PRIMARY KEY,
    StaffName VARCHAR(50) NOT NULL,
    StaffMobile INT NOT NULL,
    StaffDateJoined SMALLDATETIME NOT NULL,
    TeamID INT NOT NULL,
    CONSTRAINT FK_Staff_Team
        FOREIGN KEY (TeamID) REFERENCES Team(TeamID)
);

ALTER TABLE Team
ADD CONSTRAINT FK_Team_Leader
FOREIGN KEY (TeamLeaderID) REFERENCES Staff(StaffID);

/* ============================
   CATEGORY STRUCTURE
   ============================ */
CREATE TABLE SubCategory (
    SubCatID TINYINT PRIMARY KEY,
    SubCatDesc VARCHAR(200) NOT NULL,
    CatID INT NOT NULL,
    CONSTRAINT FK_SubCategory_Category
        FOREIGN KEY (CatID) REFERENCES Category(CatID)
);

/* ============================
   LISTINGS & PROMOTION
   ============================ */
CREATE TABLE Listing (
    ListingID INT PRIMARY KEY,
    ListDesc VARCHAR(255) NOT NULL,
    ListDateTime DATETIME NOT NULL,
    ListPrice NUMERIC(15,2) CHECK (ListPrice >= 0) NOT NULL,
    ListStatus VARCHAR(10) NOT NULL,
    SellerID INT NOT NULL,
    SubCatID INT NOT NULL,
    CONSTRAINT FK_Listing_Seller
        FOREIGN KEY (SellerID) REFERENCES Seller(SellerID),
    CONSTRAINT FK_Listing_SubCategory
        FOREIGN KEY (SubCatID) REFERENCES SubCategory(SubCatID)
);

CREATE TABLE ListingPhoto (
    ListingID INT NOT NULL,
    Photo VARBINARY(MAX),
    CONSTRAINT FK_ListingPhoto_Listing
        FOREIGN KEY (ListingID) REFERENCES Listing(ListingID)
);

CREATE TABLE BumpOrder (
    BumpOrderID INT PRIMARY KEY,
    PurchaseDate SMALLDATETIME NOT NULL,
    SellerID INT NOT NULL,
    BumpID TINYINT NOT NULL,
    ListingID INT NOT NULL,
    CONSTRAINT FK_BumpOrder_Seller
        FOREIGN KEY (SellerID) REFERENCES Seller(SellerID),
    CONSTRAINT FK_BumpOrder_Bump
        FOREIGN KEY (BumpID) REFERENCES Bump(BumpID),
    CONSTRAINT FK_BumpOrder_Listing
        FOREIGN KEY (ListingID) REFERENCES Listing(ListingID)
);

/* ============================
   OFFERS & REVIEWS
   ============================ */
CREATE TABLE Offer (
    OfferID INT PRIMARY KEY,
    BuyerID INT NOT NULL,
    ListingID INT NOT NULL,
    OfferPrice NUMERIC(15,2) CHECK (OfferPrice >= 0) NOT NULL,
    OfferStatus VARCHAR(9) NOT NULL,
    OfferDate DATE NOT NULL,
    CONSTRAINT FK_Offer_Buyer
        FOREIGN KEY (BuyerID) REFERENCES Buyer(BuyerID),
    CONSTRAINT FK_Offer_Listing
        FOREIGN KEY (ListingID) REFERENCES Listing(ListingID)
);

CREATE TABLE Review (
    ReviewID INT PRIMARY KEY,
    MemberType VARCHAR(50) NOT NULL,
    ItemRank INT NOT NULL,
    DeliveryRank INT NOT NULL,
    CommunicationRank INT NOT NULL,
    Comment VARCHAR(300),
    ReviewDate SMALLDATETIME NOT NULL DEFAULT GETDATE()
);

/* ============================
   CHAT SYSTEM
   ============================ */
CREATE TABLE Chat (
    ChatID INT PRIMARY KEY,
    BuyerID INT NOT NULL,
    ListingID INT NOT NULL,
    CONSTRAINT FK_Chat_Buyer
        FOREIGN KEY (BuyerID) REFERENCES Member(MemberID),
    CONSTRAINT FK_Chat_Listing
        FOREIGN KEY (ListingID) REFERENCES Listing(ListingID)
);

CREATE TABLE ChatMsg (
    MsgSN INT NOT NULL,
    ChatID INT NOT NULL,
    Originator INT NOT NULL,
    MsgDateTime SMALLDATETIME NOT NULL,
    Msg VARCHAR(100) NOT NULL,
    CONSTRAINT PK_ChatMsg PRIMARY KEY (MsgSN, ChatID),
    CONSTRAINT FK_ChatMsg_Chat
        FOREIGN KEY (ChatID) REFERENCES Chat(ChatID),
    CHECK (MsgDateTime <= GETDATE())
);

/* ============================
   FEEDBACK & LIKES
   ============================ */
CREATE TABLE Feedback (
    FbkID INT PRIMARY KEY,
    FbkDesc VARCHAR(50) NOT NULL,
    FbkCatID TINYINT NOT NULL,
    ByMemberID INT NOT NULL,
    OnMemberID INT NOT NULL,
    StaffID INT,
    FbkDateTime SMALLDATETIME NOT NULL,
    FbkStatus CHAR(1),
    SatisfactionRank TINYINT,
    CONSTRAINT FK_Feedback_Cat
        FOREIGN KEY (FbkCatID) REFERENCES FeedbkCat(FbkCatID),
    CONSTRAINT FK_Feedback_ByMember
        FOREIGN KEY (ByMemberID) REFERENCES Member(MemberID),
    CONSTRAINT FK_Feedback_OnMember
        FOREIGN KEY (OnMemberID) REFERENCES Member(MemberID),
    CONSTRAINT FK_Feedback_Staff
        FOREIGN KEY (StaffID) REFERENCES Staff(StaffID)
);

CREATE TABLE Likes (
    BuyerID INT NOT NULL,
    ListingID INT NOT NULL,
    DateLiked SMALLDATETIME NOT NULL,
    CONSTRAINT PK_Likes PRIMARY KEY (BuyerID, ListingID),
    CONSTRAINT FK_Likes_Buyer
        FOREIGN KEY (BuyerID) REFERENCES Member(MemberID),
    CONSTRAINT FK_Likes_Listing
        FOREIGN KEY (ListingID) REFERENCES Listing(ListingID),
    CHECK (DateLiked <= GETDATE())
);

/* ============================
   AWARDS & WINS
   ============================ */
CREATE TABLE Wins (
    AwardID TINYINT NOT NULL,
    TeamID TINYINT NOT NULL,
    DateAwarded SMALLDATETIME NOT NULL,
    CONSTRAINT PK_Wins PRIMARY KEY (AwardID, TeamID, DateAwarded),
    CONSTRAINT FK_Wins_Award
        FOREIGN KEY (AwardID) REFERENCES Award(AwardID),
    CONSTRAINT FK_Wins_Team
        FOREIGN KEY (TeamID) REFERENCES Team(TeamID),
    CHECK (DateAwarded <= GETDATE())
);
