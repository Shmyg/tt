CREATE OR REPLACE package body OPSUPP.User_management
IS
 
Function  getEncPassword( pos_Password in varchar2) RETURN varchar2
 IS
      TYPE TANNUMBERARRAY IS TABLE OF INTEGER INDEX BY BINARY_INTEGER;
       losKEY  VARCHAR2 (16) := 'borlandcborlandc';
       lanEncNewPassw TANNUMBERARRAY;
       lonNewPasswordLength   INTEGER := 0;
       lonIndex INTEGER := 0;
       lianNewPassword TANNUMBERARRAY;
       losEncPassword VARCHAR2(200) := NULL;
    BEGIN
       FOR i IN 1..LENGTH(pos_Password) LOOP
            lianNewPassword(i) := ASCII(SUBSTR(pos_Password,i,1));
       END LOOP;
        IF (lianNewPassword.FIRST IS NOT NULL )
        THEN
          lonNewPasswordLength := lianNewPassword.LAST;   
          FOR lonIndex IN lianNewPassword.FIRST .. lianNewPassword.LAST 
          LOOP
             lanEncNewPassw (lonIndex) := lianNewPassword (lonIndex);
          END LOOP;
          lianNewPassword.DELETE;
          FOR lonIndex IN lanEncNewPassw.FIRST .. lanEncNewPassw.LAST 
          LOOP
             lianNewPassword (lonNewPasswordLength - lonIndex + 1) := 65 + MOD (lanEncNewPassw (lonIndex)- 2  * BITAND (  lanEncNewPassw (lonIndex),  ASCII (SUBSTR (   losKEY,   1 + MOD (lonIndex - 1, LENGTH (losKEY)),   1))  + lonNewPasswordLength)+ (ASCII ( SUBSTR (losKEY,1 + MOD (lonIndex - 1, LENGTH (losKEY)),1))   +  lonNewPasswordLength),24);
          END LOOP;
       ELSE
          lianNewPassword.DELETE;
       END IF;
       FOR R IN lianNewPassword.FIRST .. lianNewPassword.LAST 
        LOOP
          losEncPassword := losEncPassword || CHR(lianNewPassword(R));
        END LOOP;
       RETURN   losEncPassword ; 
       EXCEPTION
         WHEN NO_DATA_FOUND THEN
           NULL;
         WHEN OTHERS THEN
           -- Consider logging the error and then re-raise
           DBMS_OUTPUT.PUT_LINE(SQLCODE);
           DBMS_OUTPUT.PUT_LINE(SQLERRM);
           RAISE;       
    END getEncPassword;
    
    
Function GET_UN_USERNAME (v_description in Varchar2,vusername in Varchar2) RETURN varchar2
    is
cnt   int:=1;
v_username varchar2(16);
unique_name boolean :=false;
chk_firstname_lastname boolean:=false;
chk_firstname_middlename boolean :=false;
chk_space_in_username varchar(2):='00' ;
chk_givenusername boolean :=false;
cnt_id int:=1;
 ERR_NAME Exception;
Begin
while not unique_name 
loop
Begin
            select  regexp_instr(vusername,' ') into chk_space_in_username from dual;
            if (vusername is not null and  not  chk_givenusername and chk_space_in_username=0 )
            then
                v_username :=vusername;
                chk_givenusername :=true;
            Elsif  (not chk_firstname_middlename)
            Then
            chk_firstname_middlename :=true;
             v_username :=Upper(substr(trim(v_description),1,4) || substr(trim(v_description),instr(trim(v_description),' ',1)+1,4));
              select  regexp_instr(v_username,' ') into chk_space_in_username from dual;
              Elsif (not chk_firstname_lastname)
              Then
               chk_firstname_lastname :=true;
             v_username :=Upper(substr(trim(v_description),1,4) || substr(trim(v_description),instr(trim(v_description),' ',1,2)+1,4));
              select  regexp_instr(v_username,' ') into chk_space_in_username from dual;
              Else
                     Select Upper(substr(trim(v_description),1,4)||lpad(cnt_id,4,'0')) into v_username from dual;
                       cnt_id :=cnt_id +1;
                       select  regexp_instr(v_username,' ') into chk_space_in_username from dual;
                       if chk_space_in_username<>0 
                       then
                       Raise ERR_NAME;
                       End if;
end if;

Dbms_output.put_line(v_username);
If chk_space_in_username= 0 then 
        Begin
        Select  nvl(count(1),0) into  cnt from  users 
        where username = v_username;
        dbms_output.put_line (cnt);
        if  cnt = 0 
        then 
            unique_name :=true;
        End if ;
        exception when NO_DATA_FOUND  then 
        unique_name :=true;
        End;
--v_username
End if;
chk_space_in_username:=0;
if cnt_id >99 then 
exit;
end if ;
Exception  When ERR_NAME then 
return '-1';
End; 
End loop;
return v_username;

end get_un_username;

Procedure Create_user(v_description in Varchar2, v_group_user in Varchar2, v_t_username in varchar2, v_username out varchar2, v_status out char, Err_msg out varchar2)
IS
 los_USERS USERS.USERNAME%TYPE := NULL;
   los_GROUP USERS.GROUP_USER%TYPE := NULL;
   los_PASSWORD USERS.USERNAME%TYPE := NULL;
   Error_username Exception;
   Error_sameDescription Exception; 
   Error_NOGroup   Exception;
   Error_description_space Exception;
   cnt_description int:=0;
Begin

Select count(1)  into cnt_description from  users where description = v_description;

If cnt_description <>0 
then raise Error_sameDescription;
End if;

Select count(1)  into cnt_description from  users where username = v_group_user and  USER_TYPE= 'G';

if cnt_description =0 
then    
raise Error_NOGroup;  
End if;

if   instr(trim(v_description),' ',1,1) < 4 
then 
Raise   Error_description_space;
End if;

los_users :=GET_UN_USERNAME(v_description,v_t_username);
If los_users = '-1' then 
raise ERROR_USERNAME;
End if;
los_PASSWORD  := getEncPassword( los_USERS ) ;


 INSERT INTO USERS (USERNAME, DESCRIPTION, COST_CENTER, ENTDATE, MODDATE, MODIFIED, GROUP_USER, REC_VERSION, USER_TYPE, MAS_DEFAULT_LNG, PASSWORD_EXPIRATION_DATE, REGION_ID)
         VALUES(los_users, v_Description, 1, trunc(sysdate-1), sysdate-1 , 'X', v_group_user, 1, 'U', 5, trunc(sysdate -1 ), 5 );      




EXECUTE IMMEDIATE  'CREATE USER '||los_USERS||' IDENTIFIED BY '||los_PASSWORD||' DEFAULT TABLESPACE DATA TEMPORARY TABLESPACE TEMP PROFILE DEFAULT ACCOUNT UNLOCK';
         EXECUTE IMMEDIATE  'GRANT CONNECT TO '||los_USERS;
         EXECUTE IMMEDIATE  'GRANT BSCS_ROLE TO '||los_USERS;
         EXECUTE IMMEDIATE  'ALTER USER '||los_USERS||' DEFAULT TABLESPACE DATA';
         EXECUTE IMMEDIATE  'ALTER USER '||los_USERS||' TEMPORARY TABLESPACE TEMP';
         EXECUTE IMMEDIATE  'ALTER USER '||los_USERS||' QUOTA 0 ON DATA';
         EXECUTE IMMEDIATE  'ALTER USER '||los_USERS||' DEFAULT ROLE ALL';
         EXECUTE IMMEDIATE  'ALTER USER '||los_USERS||' GRANT CONNECT THROUGH JAVASERVER AUTHENTICATION REQUIRED';

Commit;
ERR_MSG :='';
v_status:='S';
v_username :=los_USERS;

Exception 
When Error_description_space 
Then 
ERR_MSG :='Firstname cannot be identified,try tentative name'  ;
v_status:='F';
rollback;
When Error_NoGroup then
ERR_MSG :='Correct  Group Please, Groupname is wrong'  ;
v_status:='F';
rollback;
When DUP_VAL_ON_INDEX
Then 
ERR_MSG :='Duplicated Key' || substr(sqlerrm,1,40) ;
v_status:='F';
rollback;
When  Error_sameDescription 
Then 
ERR_MSG :='Duplicated Description, change it or change group of the User';
v_status:='F';
rollback;
when ERROR_USERNAME
Then 
rollback;
ERR_MSG :='USERNAME cannot be created, Try tentative name manually';
v_status:='F';
When others then 
ERR_MSG :='Others Error' || substr(sqlerrm,1,40);
v_status:='F';
rollback; 
End;
End User_management;
/

