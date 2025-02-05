/*
1. Traffic Sources Session Volume – Identifies the number of sessions per traffic source
*/

SELECT 
    utm_source,
    utm_campaign,
    http_referer,
    COUNT(DISTINCT website_session_id) AS sessions
FROM
    website_sessions
WHERE
    created_at < '2012-04-12'
GROUP BY utm_source , utm_campaign , http_referer
ORDER BY sessions DESC;


/*
2. Conversion Rate Analysis – Calculates session-to-order conversion rates for specific campaigns
*/

SELECT 
    COUNT(DISTINCT w.website_session_id) AS sessions,
    COUNT(DISTINCT o.order_id) AS orders,
    COUNT(DISTINCT o.order_id) / COUNT(DISTINCT w.website_session_id) AS conversion_rate
FROM
    website_sessions w
        LEFT JOIN
    orders o ON w.website_session_id = o.website_session_id
WHERE
    w.created_at < '2012-04-14'
        AND utm_source = 'gsearch'
        AND utm_campaign = 'nonbrand';


/*
3. Bid Optimization – Aggregates session data by week to track trends
*/

SELECT 
    YEAR(created_at),
    WEEK(created_at),
    min(date(created_at)) as week_start,
    count(distinct website_session_id) as sessions
FROM
    website_sessions
WHERE
    website_session_id BETWEEN 100000 AND 115000
group by 1, 2;


/*
4. Pivoting Order Data – Breaks down orders by item count
*/

SELECT 
    primary_product_id,
    COUNT(DISTINCT CASE
            WHEN items_purchased = 1 THEN order_id
            ELSE NULL
        END) AS single_item_orders,
    COUNT(DISTINCT CASE
            WHEN items_purchased = 2 THEN order_id
            ELSE NULL
        END) AS two_item_orders,
    COUNT(DISTINCT order_id) AS total_orders
FROM
    orders
WHERE
    order_id BETWEEN 31000 AND 32000
GROUP BY 1;


/*
5. Session Trends for ‘gsearch’ Traffic – Analyzes weekly session volume for a specific traffic source
*/

SELECT 
	YEAR(created_at),
    WEEK(created_at),
    MIN(DATE(created_at)) AS week_start_at,
    COUNT(DISTINCT website_session_id) AS sessions
FROM
    website_sessions
WHERE
    created_at < '2012-05-12'
        AND utm_source = 'gsearch'
        AND utm_campaign = 'nonbrand'
GROUP BY 1, 2;

/*
6. Device Type Conversion Analysis – Compares session conversion rates across devices
*/

SELECT 
    w.device_type,
    COUNT(DISTINCT w.website_session_id) AS sessions,
    COUNT(DISTINCT o.order_id) AS orders,
    COUNT(DISTINCT o.order_id) / COUNT(DISTINCT w.website_session_id) AS conversion_rate
FROM
    website_sessions w
        LEFT JOIN
    orders o ON w.website_session_id = o.website_session_id
WHERE
    w.created_at < '2012-05-11'
        AND utm_source = 'gsearch'
        AND utm_campaign = 'nonbrand'
GROUP BY w.device_type;


/*
7. Segment Trending – Tracks weekly session trends by device type
*/

SELECT 
    MIN(DATE(created_at)) AS week,
    COUNT(DISTINCT CASE
            WHEN device_type = 'desktop' THEN website_session_id
            ELSE NULL
        END) AS desktop,
    COUNT(DISTINCT CASE
            WHEN device_type = 'mobile' THEN website_session_id
            ELSE NULL
        END) AS mobile
FROM
    website_sessions
WHERE
    created_at < '2012-06-09'
        AND created_at > '2012-04-15'
        AND utm_source = 'gsearch'
        AND utm_campaign = 'nonbrand'
GROUP BY WEEK(created_at);