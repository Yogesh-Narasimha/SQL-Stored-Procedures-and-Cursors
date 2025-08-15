DELIMITER $$

CREATE PROCEDURE ListAllSubscribers()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE sub_name VARCHAR(100);
    DECLARE full_list VARCHAR(1000) DEFAULT ''; -- Variable to store all names
    
    -- Declare the cursor
    DECLARE cur CURSOR FOR SELECT SubscriberName FROM Subscribers;
    
    -- Declare the handler for when the cursor reaches the end
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    -- Open the cursor
    OPEN cur;
    
    -- Loop through the results
    read_loop: LOOP
        FETCH cur INTO sub_name;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        -- Append the current subscriber name to the list
        SET full_list = CONCAT(full_list, sub_name, ', ');
    END LOOP;
    
    -- Close the cursor
    CLOSE cur;
    
    -- Trim the trailing comma and space
    SET full_list = SUBSTRING(full_list, 1, LENGTH(full_list) - 2);
    
    -- Print the final, single result set
    SELECT CONCAT('Subscriber Names: ', full_list) AS AllSubscribers;
END$$

DELIMITER ;

-- Call the procedure to test it:
 CALL ListAllSubscribers();
