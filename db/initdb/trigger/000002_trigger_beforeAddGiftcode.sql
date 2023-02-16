drop function if exists chkGiftcodeBeforeInsert cascade;
create function chkGiftcodeBeforeInsert() 
returns trigger
as $trigfunc$
begin	
	-- Kiểm tra ngày phát hành phải nhỏ hơn ngày hết hạn
	if new.startdate >= new.expiredate then
		raise exception 'Started date is later than expired date.';
	end if;
	return new;
end $trigfunc$ language plpgsql;

create trigger chkGiftcodeBeforeInsertTrig
before insert on "giftcode"
for each row execute function chkGiftcodeBeforeInsert();