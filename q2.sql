DELIMITER $$

CREATE PROCEDURE GetWatchHistoryBySubscriber(IN sub_id INT)
BEGIN
    SELECT
        S.Title,
        WH.WatchTime
    FROM
        WatchHistory WH
    JOIN
        Shows S ON WH.ShowID = S.ShowID
    WHERE
        WH.SubscriberID = sub_id;
END$$

DELIMITER ;

-- Example call to the procedure:
-- CALL GetWatchHistoryBySubscriber(1);