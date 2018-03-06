Required:
C:\Windows\bscs.ini
C:\Onlines\44082\bin\win32\sql.config

webservices must be running
webservices are only running if CMS is running
exmple: http://10.110.8.171:10003/wsi/view/web-services

when logging in, onlines check the DB provided in the windows/bscs.ini and then go to win32/sql.config to verify the DB there. So the DB must be entered in both files.
It is also possible to comment the DB in bscs.ini. But instead of giving a selection of DBs as it is supposed to do, it simply took the first entry in sql.config. 
A selection makes also not much sense because the WebServicesServiceAdaptor in bscs.ini needs to point to specific webservices - so: just keep the DB entry in the bscs.ini.

bscs.ini
the only elements needed are:
- [BSCS-DATABASES]
- [LoginAdaptor]
- [WebServicesServiceAdaptor]
- [LicenseManagement]
other login adaptors only needed if configured as such in [LoginAdaptor]



sql.config structure
<databases>
<database name="BSCSTSTT">
  <provider name="Oracle" namespace="Oracle.DataAccess.Client" assembly="Oracle.DataAccess" brand="28"/>
  <autocommit value="false"/>
  <named_parameters value="true" prefix=":"/>
  <multiple_connections value="false"/>
  <connection_string value="Data Source=BSCSTSTT"/>
 </database>
</databases>