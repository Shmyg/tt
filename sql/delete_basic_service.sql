delete from mpdoptab where srvcode in (select srvcode from mpssvtab where svcode >= 456);
delete from service_parameter where svcode >= 456;
delete from mpulknxv  where sscode >= 456;
delete from mpssvtab where svcode >= 456;
