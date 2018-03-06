CREATE OR REPLACE Package OPSUPP.User_management
 authid current_user
IS
Function  GetEncPassword( pos_Password in varchar2) RETURN varchar2;
Function GET_UN_USERNAME(v_description in Varchar2,vusername in Varchar2) RETURN varchar2;
Procedure Create_user(v_description in Varchar2, v_group_user in Varchar2, v_t_username in varchar2, v_username out varchar2, v_status out char, Err_msg out varchar2);
    
End User_management;
/

