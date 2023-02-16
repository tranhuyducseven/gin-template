drop function if exists chkStaffBeforeInsert cascade;
create function chkStaffBeforeInsert() 
returns trigger
as $trigfunc$
begin
	-- Kiểm tra lương nhân viên phải lớn hơn 0
	if new.salary <= 0 then
		raise exception 'Staff salary is less than or equal 0.';
	end if;
	return new;
end $trigfunc$ language plpgsql;

create trigger chkStaffBeforeInsertTrig
before insert on "staff"
for each row execute function chkStaffBeforeInsert();