/*
============================================================
 FILE: 02_ETL_Data_Load.sql
 PROJECT: Music Service DB
 PURPOSE: This script performs the ETL process. It extracts
 data from the 'RawTracksData' staging table,
 transforms it by linking IDs, and loads it into the
 clean, normalized tables.
============================================================
*/

-- 1. Set the correct database context
USE MusicServiceDB; -- Change this if your DB name is different
GO

/*
------------------------------------------------------------
 STEP 2: POPULATE THE 'Artists' TABLE
 Extracts unique, non-null artists from the raw data.
------------------------------------------------------------
*/
INSERT INTO Artists (ArtistName)
SELECT DISTINCT
    artists
FROM
    RawTracksData
WHERE
    -- Check for existence to prevent duplicates if run multiple times
    artists NOT IN (SELECT ArtistName FROM Artists)
    -- Filter out NULL values from the source
    AND artists IS NOT NULL;
GO

PRINT 'Artists table populated successfully.';
GO

/*
------------------------------------------------------------
 STEP 3: POPULATE THE 'Albums' TABLE
 Extracts unique albums and links them to their ArtistID.
------------------------------------------------------------
*/
INSERT INTO Albums (AlbumName, ArtistID)
SELECT DISTINCT
    RT.album_name,
    A.ArtistID
FROM
    RawTracksData AS RT
JOIN
    -- Join to get the newly created ArtistID
    Artists AS A ON RT.artists = A.ArtistName
WHERE
    -- Check for existence
    RT.album_name NOT IN (SELECT AlbumName FROM Albums)
    -- Filter out any records with NULL essential data
    AND RT.album_name IS NOT NULL
    AND RT.artists IS NOT NULL;
GO

PRINT 'Albums table populated successfully.';
GO

/*
------------------------------------------------------------
 STEP 4: POPULATE THE 'Tracks' TABLE
 Loads all tracks and links them to their
 ArtistID and AlbumID.
------------------------------------------------------------
*/
INSERT INTO Tracks (TrackName, AlbumID, ArtistID)
SELECT
    RT.track_name,
    AL.AlbumID,
    A.ArtistID
FROM
    RawTracksData AS RT
JOIN
    -- Join to get ArtistID
    Artists AS A ON RT.artists = A.ArtistName
JOIN
    -- Join to get AlbumID, ensuring to match on ArtistID
    -- as well, in case two artists have an album with the same name.
    Albums AS AL ON RT.album_name = AL.AlbumName AND A.ArtistID = AL.ArtistID
WHERE
    -- Filter out any records with NULL essential data
    RT.track_name IS NOT NULL
    AND RT.album_name IS NOT NULL
    AND RT.artists IS NOT NULL;
GO

PRINT 'Tracks table populated successfully.';
PRINT '--- ETL PROCESS COMPLETE ---';
GO