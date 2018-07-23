USE `table`;
DROP function IF EXISTS `KoelnerPhonetic`;

DELIMITER $$
USE `table`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `KoelnerPhonetic`(strWord VARCHAR(255), intLen integer) RETURNS varchar(250) CHARSET latin1
BEGIN
	declare Word VARCHAR(255);
	declare WordLen integer;
	declare checkLen integer;
	declare code VARCHAR(255);
	declare PhoneticCode VARCHAR(255);
	declare intX integer;
    SET checklen = coalesce(intlen,255);
    SET Word = lower(substring(strWord,1,checkLen));
	if length(Word) < 1 then return '0'; end if;
    
    -- Ersetzen von einzelnen Sonderzeichen/Kombinationen
	SET  word=replace(word,'v','f');
	SET  word=replace(word,'w','f');
	SET  word=replace(word,'j','i');
	SET  word=replace(word,'y','i');
	SET  word=replace(word,'ph','f');
	SET  word=replace(word,'ä','a');
	SET  word=replace(word,'ö','o');
	SET  word=replace(word,'ü','u');
	SET  word=replace(word,'ß','ss');
	SET  word=replace(word,'é','e');
	SET  word=replace(word,'è','e');
	SET  word=replace(word,'à','a');
	SET  word=replace(word,'ç','c');
    SET  WordLen=length(Word);
    SET  Code='';
    
    -- Anlautprüfung
	If WordLen=1 Then set Word=CONCAT(Word, ' '); End If;
	if substring(Word,1,1) = 'c' then
	-- vor a,h,k,l,o,q,r,u,x
	if position(substring(Word,2,1) in 'ahkloqrux')>0 then
	  set Code = CONCAT(Code, '4');
	else
	  set Code = CONCAT(Code, '8');
	end if;     
	  set intX = 2;
	else
	  set intX = 1;
	end if;
    
    
    -- loop
    

  -- Code gemäß Ersetzungstabelle
  while intx<=wordlen do
   
    if position(substring(Word,intx,1) in 'aeiou')>0 then
      SET Code = CONCAT(Code, '0');
    end if;
  
    if position(substring(Word,intx,1) in 'bp')>0 then
      SET Code = CONCAT(Code, '1');
    end if;
  
    if position(substring(Word,intx,1) in 'dt')>0 then
      -- Sonderbehandlung
      if intX<wordlen then
        if position(substring(word,intx+1,1) in 'csz')>0 then
			SET Code = CONCAT(Code, '8');
	 else
	   SET Code = CONCAT(Code, '2');
	 end if;
      else
        SET Code = CONCAT(Code, '2');
      end if;
    end if;
 
    if position(substring(Word,intx,1) in 'f')>0 then
      SET Code = CONCAT(Code, '3');
    end if;
 
    if position(substring(Word,intx,1) in 'gkq')>0 then
      SET Code = CONCAT(Code, '4');
    end if;
  
    if position(substring(Word,intx,1) in 'c')>0 then
      -- Sonderbehandlung
      if intX<wordlen then
        if position(substring(word,intx+1,1) in 'ahkoqux')>0 then
   if position(substring(word,intx-1,1) in 'sz')>0 then
     SET Code = CONCAT(Code, '8');
   else
     SET Code = CONCAT(Code, '4');
   end if;
 else
   SET Code = CONCAT(Code, '8');
 end if;
      else
        SET Code = CONCAT(Code, '8');
      end if;
    end if;
 
    if position(substring(Word,intx,1) in 'x')>0 then
      -- Sonderbehandlung
      if intX>1 then
        if position(substring(word,intx-1,1) in 'ckx')>0 then
          SET Code = CONCAT(Code, '8');
	else
		SET Code = CONCAT(Code, '48');
	end if;
      else
        SET Code = CONCAT(Code, '48');
      end if;
    end if;
  
    if position(substring(Word,intx,1) in 'l')>0 then
      SET Code = CONCAT(Code, '5');
    end if;
 
    if position(substring(Word,intx,1) in 'mn')>0 then
      SET Code = CONCAT(Code, '6');
    end if;
 
    if position(substring(Word,intx,1) in 'r')>0 then
      SET Code = CONCAT(Code, '7');
    end if;
 
    if position(substring(Word,intx,1) in 'sz')>0 then
      SET Code = CONCAT(Code, '8');
    end if;
    SET intx=intx+1;
  end while;
  
	  
	  -- alle '0'- und mehrfach-Codes entfernen
	  SET intx=1;
	  SET wordlen=length(code);
	  SET phoneticcode='';
	  SET word='';
	  while intx<=wordlen do
		-- '0'-Codes entfernen
		if substring(code,intx,1)<>'0' then
		  -- doppelte Codes entfernen
		  if substring(code,intx,1)<>word then
			SET phoneticcode=CONCAT(phoneticcode, substring(code,intx,1));
		  end if;
		  SET word=substring(code,intx,1);
		end if;
		SET intx=intx+1;
	  end while;
	 
	  -- '0'-Code am Wortanfang bleibt aber bestehen!
	  if substring(code,1,1)='0' then
		SET phoneticcode = CONCAT('0', phoneticcode);
	  end if;
	   
	  return phoneticcode;
END$$

DELIMITER ;


