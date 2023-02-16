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