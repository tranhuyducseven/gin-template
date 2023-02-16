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