drop function if exists chkBookBeforeInsert cascade;
create function chkBookBeforeInsert() 
returns trigger
as $trigfunc$
begin
	-- Kiểm tra giá sách phải lớn hơn 0
	if new.price <= 0 then
		raise exception 'Book price less than or equal 0.';
	end if;
	-- Kiểm tra rating phải có giá trị [1;5]
	if new.current_rating < 1 or new.current_rating > 5 then
		raise exception 'Book rating outside of [1;5].';
	end if;
	return new;
end $trigfunc$ language plpgsql;



create trigger chkBookBeforeInsertTrig
before insert on "book"
for each row execute function chkBookBeforeInsert();