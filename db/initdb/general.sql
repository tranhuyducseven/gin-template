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


-- Add Giftcode
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


-- Add Review
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


-- Add Staff
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


-- --------------------------------------------------------------- Function
-- search by category
drop function if exists searchByCategory;
create function searchByCategory(
   categoryToSearch varchar
) 
returns table (rBoID bigint)
as $func$
begin
	-- lấy danh sách book có tên giống tên đã nhập
	return query select boid
	from category
	where acategory like ('%' || categoryToSearch || '%');
end $func$ language plpgsql;


-- search by title
drop function if exists searchByTitle;
create function searchByTitle(
   nameToSearch varchar
) 
returns table (rBoID bigint)
as $func$
begin
	-- lấy danh sách book có tên giống tên đã nhập
	return query select boid
	from book
	where bookname like ('%' || nameToSearch || '%');
end $func$ language plpgsql;

-- --------------------------------------------------------------- Procedure
-- after purchase
create or replace procedure afterPurchase(
	input_CustomerID bigint,
	in_purch_med varchar,
	input_boid bigint[]
)
as $$
declare
	lbid bigint;
	num_of_book bigint;
begin
	-- Tạo obj bill mới
	INSERT INTO "bill" DEFAULT VALUES;
	
	-- Lấy bid của bill vừa tạo
	select bid into lbid from bill order by bid desc limit 1;				
	
	-- Thêm sách vào trong mối quan hệ contain
	num_of_book = array_length(input_boid, 1);
	for i in 1..num_of_book loop
		INSERT INTO "contain" ("boid", "bid")
		VALUES (input_boid[i], lbid);
	end loop;
	
	-- Thêm sách vào trong mối quan hệ own
	for i in 1..num_of_book loop
		INSERT INTO "own" ("boid", "id")
		VALUES (input_boid[i], input_CustomerID);
	end loop;
	
	-- Thêm bill vào trong quan hệ Purchase
	INSERT INTO "purchase" ("id", "bid", "methodname", "date")
	VALUES (input_CustomerID, lbid, in_purch_med, now());
end;
$$ language plpgsql;


-- Insert book
-- Proc thêm Ebook từ book đã có
drop procedure if exists insertEBook;
create procedure insertEBook(aBoid bigint) 
as $procebook$
begin
	insert into "ebook" ("boid") values (aBoid);
end $procebook$ language plpgsql;

-- Proc thêm Audiobook từ book đã có
drop procedure if exists insertAudioBook;
create procedure insertAudioBook(aBoid bigint) 
as $procebook$
begin
	insert into "audiobook" ("boid") values (aBoid);
end $procebook$ language plpgsql;


-- Proc thêm book, có thể nhập thêm loại book
drop procedure if exists insertBook;
create procedure insertBook(
	aBookname varchar,
	aPublishdate date,
	aPrice bigint,
	aRating real,
	aPid bigint,
	aEid bigint,
	bookType varchar
) 
as $proc$
declare
	tBoid bigint;
begin
	-- Nhập sách vào trong DB
	INSERT INTO "book" ("bookname", "publishdate", "price", "current_rating", "pid", "eid")
	VALUES (aBookname, aPublishdate, aPrice, aRating, aPid, aEid);
	-- Thêm sách vào trong phân loại nếu có nhập phân loại
	if bookType = NULL then
		raise notice 'bookType bi null.';
	else
		select boid into tBoid from book order by boid desc limit 1;
		raise notice 'ID moi duoc tao ra la: %', tBoid;
		if bookType = 'EBook' then
			call insertEBook(tBoid);
		elseif bookType = 'AudioBook' then
			call insertAudioBook(tBoid);
		end if;
	end if;
end $proc$ language plpgsql;