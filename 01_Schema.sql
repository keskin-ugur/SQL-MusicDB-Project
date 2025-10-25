/*
============================================================
 FILE: 01_Schema.sql
 PROJECT: Music Service DB
 PURPOSE: Creates the full database schema including all
 tables, primary keys, and foreign keys.
============================================================
*/

-- 1. Artists Table
CREATE TABLE Artists (
    ArtistID INT PRIMARY KEY IDENTITY(1,1),
    -- Using NVARCHAR(MAX) to prevent 'string truncated' errors
    -- from complex artist names in the raw data.
    ArtistName NVARCHAR(MAX) NOT NULL
);

-- 2. Albums Table
CREATE TABLE Albums (
    AlbumID INT PRIMARY KEY IDENTITY(1,1),
    -- Using NVARCHAR(MAX) for long album names.
    AlbumName NVARCHAR(MAX) NOT NULL,
    ArtistID INT NOT NULL,
    FOREIGN KEY (ArtistID) REFERENCES Artists(ArtistID)
    -- Note: ReleaseYear was removed as it's not present
    -- in this specific Kaggle dataset.
);

-- 3. Tracks Table
CREATE TABLE Tracks (
    TrackID INT PRIMARY KEY IDENTITY(1,1),
    -- Using NVARCHAR(MAX) for long track names.
    TrackName NVARCHAR(MAX) NOT NULL,
    AlbumID INT NOT NULL,
    ArtistID INT NOT NULL,
    FOREIGN KEY (AlbumID) REFERENCES Albums(AlbumID),
    FOREIGN KEY (ArtistID) REFERENCES Artists(ArtistID)
    -- Note: DurationSeconds was removed as it's not present
    -- in this specific Kaggle dataset.
);

-- 4. Users Table
-- This table will be populated by our application,
-- not the Kaggle data.
CREATE TABLE Users (
    UserID INT PRIMARY KEY IDENTITY(1,1),
    Username NVARCHAR(50) NOT NULL UNIQUE,
    Email NVARCHAR(100) NOT NULL UNIQUE
);

-- 5. Playlists Table
CREATE TABLE Playlists (
    PlaylistID INT PRIMARY KEY IDENTITY(1,1),
    PlaylistName NVARCHAR(100) NOT NULL,
    UserID INT NOT NULL,
    DateCreated DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- 6. Playlist_Tracks (Junction Table)
-- This is the key to our many-to-many relationship
-- between Playlists and Tracks.
CREATE TABLE Playlist_Tracks (
    PlaylistTrackID INT PRIMARY KEY IDENTITY(1,1),
    PlaylistID INT NOT NULL,
    TrackID INT NOT NULL,
    DateAdded DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (PlaylistID) REFERENCES Playlists(PlaylistID),
    FOREIGN KEY (TrackID) REFERENCES Tracks(TrackID),
    -- Ensures a track can only be added to a playlist once
    UNIQUE (PlaylistID, TrackID)
);