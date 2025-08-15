DELIMITER $$

CREATE PROCEDURE SubscriberWatchHistoryReport()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE sub_id INT;
    DECLARE sub_name VARCHAR(100);
    
    -- Declare the cursor
    DECLARE cur_subs CURSOR FOR SELECT SubscriberID, SubscriberName FROM Subscribers;
    
    -- Declare the handler for when the cursor reaches the end
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    OPEN cur_subs;
    
    read_loop: LOOP
        FETCH cur_subs INTO sub_id, sub_name;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        -- Print a heading for each subscriber
        SELECT CONCAT('--- Watch History for ', sub_name, ' (ID: ', sub_id, ') ---');
        
        -- Call the procedure to get and print the watch history for the current subscriber
        CALL GetWatchHistoryBySubscriber(sub_id);
    END LOOP;
    
    CLOSE cur_subs;
END$$

DELIMITER ;

-- Example call to the procedure:
 CALL SubscriberWatchHistoryReport();