/*
============================================================
 FILE: 03_Simulation_and_Analysis.sql
 PROJECT: Music Service DB
 PURPOSE: Simulates user activity and runs final analysis.
============================================================
*/

USE MusicServiceDB; -- Set database context
GO

/*
============================================================
 PART 1: SIMULATE USER DATA
 Populates Users, Playlists, and Playlist_Tracks.
 This sample data was generated (with AI assistance) to
 simulate application usage and provide a basis for analysis.
============================================================
*/

-- 1.1: Create sample users
INSERT INTO Users (Username, Email)
VALUES
('john_doe', 'john@mail.com'),
('jane_smith', 'jane@mail.com'),
('music_lover_99', 'ml99@mail.com');
GO

-- 1.2: Create sample playlists for our users
INSERT INTO Playlists (PlaylistName, UserID)
VALUES
('Johns Rock Archive', 1), -- UserID = 1
('Janes Pop Mix', 2),      -- UserID = 2
('Morning Run', 2),        -- UserID = 2
('All-Time Legends', 3);    -- UserID = 3
GO

-- 1.3: Add real tracks (from our 'Tracks' table) to the playlists
-- Note: These track names are known to be in the Kaggle dataset.
INSERT INTO Playlist_Tracks (PlaylistID, TrackID)
SELECT
    1 AS PlaylistID, -- 'Johns Rock Archive'
    TrackID
FROM Tracks
WHERE TrackName IN ('Bohemian Rhapsody - Remastered 2011', 'Stairway to Heaven - Remastered', 'Smells Like Teen Spirit');
GO

INSERT INTO Playlist_Tracks (PlaylistID, TrackID)
SELECT
    2 AS PlaylistID, -- 'Janes Pop Mix'
    TrackID
FROM Tracks
WHERE TrackName IN ('Blinding Lights', 'As It Was', 'Levitating');
GO

INSERT INTO Playlist_Tracks (PlaylistID, TrackID)
SELECT
    3 AS PlaylistID, -- 'Morning Run'
    TrackID
FROM Tracks
WHERE TrackName IN ('Blinding Lights', 'Take on Me', 'Don''t Stop Me Now - Remastered 2011');
GO

INSERT INTO Playlist_Tracks (PlaylistID, TrackID)
SELECT
    4 AS PlaylistID, -- 'All-Time Legends'
    TrackID
FROM Tracks
WHERE TrackName IN ('Bohemian Rhapsody - Remastered 2011', 'Smells Like Teen Spirit', 'Billie Jean');
GO

PRINT 'Simulation data (Users, Playlists, Playlist_Tracks) added.';
GO

/*
============================================================
 PART 2: ANALYSIS & REPORTING QUERIES
 Final queries to answer business questions using the
 populated database.
============================================================
*/

-- QUERY 1: TOP POPULAR TRACKS
-- Finds tracks most frequently added to playlists.
SELECT
    T.TrackName,
    A.ArtistName,
    COUNT(PT.TrackID) AS PlaylistCount
FROM
    Playlist_Tracks AS PT
JOIN
    Tracks AS T ON PT.TrackID = T.TrackID
JOIN
    Artists AS A ON T.ArtistID = A.ArtistID
GROUP BY
    T.TrackID, T.TrackName, A.ArtistName
ORDER BY
    PlaylistCount DESC;
GO

-- QUERY 2: MOST ACTIVE USERS
-- Finds users who have created the most playlists.
SELECT
    U.Username,
    COUNT(P.PlaylistID) AS TotalPlaylists
FROM
    Users AS U
JOIN
    Playlists AS P ON U.UserID = P.UserID
GROUP BY
    U.UserID, U.Username
ORDER BY
    TotalPlaylists DESC;
GO

-- QUERY 3: CONTENTS OF A SPECIFIC PLAYLIST
-- Shows all tracks for the 'Morning Run' playlist (ID=3).
SELECT
    T.TrackName,
    A.ArtistName
FROM
    Playlist_Tracks AS PT
JOIN
    Tracks AS T ON PT.TrackID = T.TrackID
JOIN
    Artists AS A ON T.ArtistID = A.ArtistID
WHERE
    PT.PlaylistID = 3; -- Change ID to inspect other playlists
GO