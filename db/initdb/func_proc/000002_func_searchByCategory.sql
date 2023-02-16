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