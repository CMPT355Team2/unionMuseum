-- when insert a new works trigger a funtion which can help locate this work into storage.
CREATE OR REPLACE FUNCTION insert_new_works() 
RETURNS trigger AS $insert_new_works_f$
BEGIN

	insert into works_locations 
		select new.wscode, new.wsacronym, new.wsmname, 'Storage', new.wsmname, 'patron', new.wsadateacq, null
		WHERE new.wsadateacq is not null;

RETURN NEW;
END;
$insert_new_works_f$ LANGUAGE plpgsql;


DROP TRIGGER IF EXISTS insert_new_works_f ON works;
CREATE TRIGGER insert_new_works_f AFTER INSERT ON works FOR EACH ROW EXECUTE PROCEDURE insert_new_works();



-- after inserted all the new relationships of works and locations, try to update the previous locations end time
CREATE OR REPLACE FUNCTION wl_date_change() 
RETURNS trigger AS $wl_date_change_f$
BEGIN

	UPDATE works_locations SET wletime = NEW.wlstime 
	WHERE wlacronym = NEW.wlacronym AND wlcode = NEW.wlcode AND wlmname1 = NEW.wlmname1 AND (wllname = 'Storage' OR wllname = 'Lobby Expo') AND wlstime < NEW.wlstime AND wletime ISNULL;

RETURN NEW;
END;
$wl_date_change_f$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS wl_date_change_f ON works_locations;
CREATE TRIGGER wl_date_change_f AFTER INSERT ON works_locations FOR EACH ROW EXECUTE PROCEDURE wl_date_change();



-- after inserted new changed exhibition's count, try to update the previous exhibition's count end time
CREATE OR REPLACE FUNCTION change_exhibition_count()
RETURNS trigger AS $change_exhibition_count_f$
BEGIN

	UPDATE changedcount SET ccsdatece = new.ccsdatecs
	WHERE ccename = new.ccename and ccsdate = new.ccsdate and ccmname = new.ccmname and ccsdatecs < new.ccsdatecs and ccsdatece is null;

RETURN NEW;
END;
$change_exhibition_count_f$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS change_exhibition_count_f ON changedcount;
CREATE TRIGGER change_exhibition_count_f AFTER INSERT ON changedcount FOR EACH ROW EXECUTE PROCEDURE change_exhibition_count();


-- trigger between owners and transactions table
CREATE OR REPLACE FUNCTION owners_transactions()
RETURNS trigger AS $owners_transactions_f$
BEGIN

	UPDATE owners SET owetime = new.owstime
	WHERE owcode = new.owcode and owacronym = new.owacronym and owmname = new.owmname and owetime is null and owstatus <> new.owstatus;
	
	insert into transactions 
		select new.owcode, new.owacronym, new.owmname, new.owinsname, new.owstime, null
		where UPPER(new.owstatus) <> UPPER('Potentially borrowed');

	insert into transactions
		select new.owcode, new.owacronym, new.owmname, new.owinsname, new.owetime, null
		where UPPER(new.owstatus) = UPPER('Potentially borrowed');

RETURN NEW;
END;
$owners_transactions_f$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS owners_transactions_f ON owners;
CREATE TRIGGER owners_transactions_f AFTER INSERT ON owners FOR EACH ROW EXECUTE PROCEDURE owners_transactions();