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