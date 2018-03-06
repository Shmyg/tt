begin
for i in (select customer_ref from tstt_payment_file)
loop
update tstt_payment_file set customer_ref = (select custcode from (select custcode from customer_all order by dbms_random.random) where rownum =1 ) where customer_ref = i.customer_ref;
end loop;
end;
/
