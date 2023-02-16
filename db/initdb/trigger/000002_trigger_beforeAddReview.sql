drop function if exists chkReviewBeforeInsert cascade;
create function chkReviewBeforeInsert() 
returns trigger
as $trigfunc$
begin	
	-- Kiểm tra rating phải có giá trị [1;5]
	if new.rating < 1 or new.rating > 5 then
		raise exception 'Review rating outside of [1;5].';
	end if;
	return new;
end $trigfunc$ language plpgsql;

create trigger chkReviewBeforeInsertTrig
before insert on "review"
for each row execute function chkReviewBeforeInsert();