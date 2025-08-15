DELIMITER $$

CREATE PROCEDURE SendWatchTimeReport()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE sub_id INT;
    DECLARE sub_has_history INT;
    
    -- Declare the cursor
    DECLARE cur_subs CURSOR FOR SELECT SubscriberID FROM Subscribers;
    
    -- Declare the handler for when the cursor reaches the end
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    OPEN cur_subs;
    
    read_loop: LOOP
        FETCH cur_subs INTO sub_id;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        -- Check if the subscriber has any watch history
        SELECT COUNT(*) INTO sub_has_history
        FROM WatchHistory
        WHERE SubscriberID = sub_id;
        
        IF sub_has_history > 0 THEN
            -- If the subscriber has a watch history, call the report procedure
            SELECT CONCAT('--- Watch History for Subscriber ID: ', sub_id, ' ---');
            CALL GetWatchHistoryBySubscriber(sub_id);
        END IF;
    END LOOP;
    
    CLOSE cur_subs;
END$$

DELIMITER ;

-- Example call to the procedure:
CALL SendWatchTimeReport();

