/*We want to reward our users who have been around the longest.  
Find the 5 oldest users.*/
SELECT 
    *
FROM
    users
ORDER BY created_at
LIMIT 5;


/*What day of the week do most users register on?
We need to figure out when to schedule an ad campgain*/
SELECT 
    DAYOFWEEK(created_at) AS day_of_week,
    COUNT(*) AS total_users
FROM
    users
GROUP BY DAYOFWEEK(created_at)
ORDER BY total_users DESC;


/*We want to target our inactive users with an email campaign.
Find the users who have never posted a photo*/
SELECT 
    username
FROM
    users
        LEFT JOIN
    photos ON users.id = photos.user_id
WHERE
    photos.id IS NULL;
    
    
   /*We're running a new contest to see who can get the most likes on a single photo.
WHO WON??!!*/
SELECT 
    users.username,
    photos.id,
    photos.image_url,
    COUNT(*) AS Total_Likes
FROM
    likes
        JOIN
    photos ON photos.id = likes.photo_id
        JOIN
    users ON users.id = likes.user_id
GROUP BY photos.id
ORDER BY Total_Likes DESC
LIMIT 1;


/*Our Investors want to know...
How many times does the average user post?*/
/*total number of photos/total number of users*/











