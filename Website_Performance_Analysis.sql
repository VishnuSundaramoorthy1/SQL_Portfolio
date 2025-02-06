/*
1. Session Volume by Entry Page – Counts the number of sessions starting on each entry page.
*/

CREATE TEMPORARY TABLE first_pageview
SELECT 
    website_session_id,
    MIN(website_pageview_id) AS minimum_page_id
FROM
    website_pageviews
WHERE
    website_pageview_id < 1000
GROUP BY website_session_id;

SELECT 
    w.pageview_url AS entry_page,
    COUNT(DISTINCT f.website_session_id) AS sessions
FROM
    first_pageview f
        LEFT JOIN
    website_pageviews w ON f.minimum_page_id = w.website_pageview_id
GROUP BY w.pageview_url;


/*
2. 
*/

SELECT 
    pageview_url, 
    COUNT(DISTINCT website_session_id) AS sessions
FROM
    website_pageviews
WHERE
    created_at < '2012-06-09'
GROUP BY pageview_url
ORDER BY sessions DESC;


/*
3. 
*/

-- step 1: find the first pageview for each session
CREATE TEMPORARY TABLE first_page_view_per_session
SELECT 
    website_session_id,
    MIN(website_pageview_id) AS first_page_view
FROM
    website_pageviews
WHERE
    created_at < '2012-06-12'
GROUP BY website_session_id;

-- step 2: find the url customer saw on first pageview
SELECT 
    wp.pageview_url AS landing_url,
    COUNT(DISTINCT first_page_view_per_session.website_session_id) AS session
FROM
    first_page_view_per_session
        LEFT JOIN
    website_pageviews wp ON first_page_view_per_session.first_page_view = wp.website_pageview_id
GROUP BY wp.pageview_url;


/*
4. BUSINESS CONTEXT: We want to see landing page performance for a certain time period
*/

-- STEP 1: Find the first website_pageview_id for relevant sessions
CREATE TEMPORARY TABLE fp_views
SELECT 
    wp.website_session_id, 
    MIN(wp.website_pageview_id) AS min_page_id
FROM
    website_pageviews wp
    INNER JOIN website_sessions ws ON wp.website_session_id = ws.website_session_id
    AND ws.created_at BETWEEN '2014-01-01' AND '2014-02-01'
GROUP BY wp.website_session_id;

-- STEP 2: Identify the landing page of each session
CREATE TEMPORARY TABLE landing_sessions
SELECT 
    fp_views.website_session_id, 
    wp.pageview_url AS landing_page
FROM
    fp_views
        LEFT JOIN
    website_pageviews wp ON fp_views.min_page_id = wp.website_session_id;

-- STEP 3: Counting pageviews for each session, to identify 'bounces'
CREATE TEMPORARY TABLE bounced_session
SELECT 
    landing_sessions.website_session_id,
    landing_sessions.landing_page,
    COUNT(wp.website_pageview_id) AS view_count
FROM
    landing_sessions
        LEFT JOIN
    website_pageviews wp ON wp.website_session_id = landing_sessions.website_session_id
GROUP BY landing_sessions.website_session_id , landing_sessions.landing_page
HAVING COUNT(wp.website_pageview_id) = 1;

-- STEP 4: Summarizing total sessions and bounced sessions, by Landing Page
SELECT 
    landing_sessions.landing_page,
    COUNT(DISTINCT landing_sessions.website_session_id) AS sessions,
    COUNT(DISTINCT bounced_session.website_session_id) AS bounced_sessions,
    COUNT(DISTINCT bounced_session.website_session_id)/ COUNT(DISTINCT landing_sessions.website_session_id) as bounce_rate
FROM
    landing_sessions
        LEFT JOIN
    bounced_session ON landing_sessions.website_session_id = bounced_session.website_session_id
GROUP BY landing_sessions.landing_page;


/*
5. 
*/

