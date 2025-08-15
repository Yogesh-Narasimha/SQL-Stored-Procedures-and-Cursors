DELIMITER $$

CREATE PROCEDURE AddSubscriberIfNotExists(IN subName VARCHAR(100))
BEGIN
    DECLARE subCount INT;
    
    -- Check if the subscriber name already exists
    SELECT COUNT(*) INTO subCount
    FROM Subscribers
    WHERE SubscriberName = subName;
    
    IF subCount = 0 THEN
        -- If the subscriber does not exist, insert a new record
        INSERT INTO Subscribers (SubscriberName, SubscriptionDate)
        VALUES (subName, CURDATE());
        SELECT 'New subscriber added successfully.';
    ELSE
        -- If the subscriber already exists, do nothing and display a message
        SELECT 'Subscriber already exists. No new record added.';
    END IF;
END$$

DELIMITER ;

-- Example calls to the procedure:
-- CALL AddSubscriberIfNotExists('Virat Kohli'); -- Should add
-- CALL AddSubscriberIfNotExists('Emily Clark');   -- Should not add