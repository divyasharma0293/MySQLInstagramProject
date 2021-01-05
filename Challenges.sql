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
SELECT 
    ROUND((SELECT 
                    COUNT(id)
                FROM
                    photos) / (SELECT 
                    COUNT(id)
                FROM
                    users),
            2);


/*user ranking by postings higher to lower*/
SELECT 
    users.username, COUNT(photos.image_url)
FROM
    users
        JOIN
    photos ON users.id = photos.user_id
GROUP BY users.id
ORDER BY 2 DESC;



/*Total Posts by users (longer versionof SELECT COUNT(*)FROM photos) */
SELECT 
    SUM(user_post.posts)
FROM
    (SELECT 
        users.username, COUNT(photos.image_url) AS posts
    FROM
        users
    JOIN photos ON users.id = photos.user_id
    GROUP BY users.id) AS user_post;
    
    
/*total numbers of users who have posted at least one time */
SELECT 
    COUNT(*)
FROM
    (SELECT 
        users.username, COUNT(photos.image_url) AS number_of_posts
    FROM
        users
    JOIN photos ON users.id = photos.user_id
    GROUP BY users.username
    HAVING number_of_posts > 0) AS total;
    
 
 
/*A brand wants to know which hashtags to use in a post
What are the top 5 most commonly used hashtags?*/
SELECT 
    tags.tag_name, COUNT(tags.tag_name) AS total
FROM
    tags
        JOIN
    photo_tags ON tags.id = photo_tags.photo_id
GROUP BY tags.id
ORDER BY total DESC
LIMIT 5;



/*We have a small problem with bots on our site...
Find users who have liked every single photo on the site*/
SELECT 
    users.id, username, COUNT(users.id) AS total_likes_by_user
FROM
    users
        JOIN
    likes ON users.id = likes.user_id
GROUP BY users.id
HAVING total_likes_by_user = (SELECT 
        COUNT(*)
    FROM
        photos);



/*We also have a problem with celebrities
Find total number of users who have never commented on a photo*/
SELECT 
    COUNT(*)
FROM
    (SELECT 
        users.username, comment_text
    FROM
        users
    LEFT JOIN comments ON users.id = comments.user_id
    GROUP BY users.id
    HAVING comment_text IS NULL) never_commented;



/*Mega Challenges
Are we overrun with bots and celebrity accounts?
Find the percentage of our users who have either never commented on a photo or have commented on every photo*/
SELECT 
    never_comments.total_never_commented AS 'Number of users never commented',
    (never_comments.total_never_commented / (SELECT 
            COUNT(*)
        FROM
            users)) * 100 AS '%',
    commented_photos.total_commented AS 'Number of users who have commented on every photo',
    (commented_photos.total_commented / (SELECT 
            COUNT(*)
        FROM
            users)) * 100 AS '%'
FROM
    (SELECT 
        COUNT(*) AS total_never_commented
    FROM
        (SELECT 
        users.username, comment_text
    FROM
        users
    LEFT JOIN comments ON users.id = comments.user_id
    GROUP BY users.id
    HAVING comment_text IS NULL) never_commented) AS never_comments
        JOIN
    (SELECT 
        COUNT(*) AS total_commented
    FROM
        (SELECT 
        users.username, COUNT(users.id) AS commented
    FROM
        users
    JOIN comments ON users.id = comments.user_id
    GROUP BY users.id
    HAVING commented = (SELECT 
            COUNT(*)
        FROM
            photos)) AS commented_on_every_photo) AS commented_photos;
