create or replace function lab1_print(arg_имя_таблицы text)
returns table(
    "Номер" text,
    "Имя столбца" text,
    "Атрибуты" text
)
as $$
declare
    var_row record;
    var_type_str text;
begin
    drop table if exists var_out_table;

    create temp table if not exists var_out_table (
        "Номер" text,
        "Имя столбца" text,
        "Атрибуты" text
    );

    for var_row in select attnum, attname, typname, atttypmod, attnotnull, description from pg_catalog.pg_attribute pga
        inner join pg_catalog.pg_type pgt on pga.atttypid = pgt.oid
        left join (select * from pg_catalog.pg_description where objoid = arg_имя_таблицы::regclass) as pgd on pga.attnum = pgd.objsubid
        where attrelid = arg_имя_таблицы::regclass and attnum >= 1
        order by attnum
    loop
        if var_row.atttypmod != -1 then
            var_type_str = format('%s(%s)', var_row.typname, var_row.atttypmod);
        else
            var_type_str = var_row.typname;
        end if;

        if var_row.attnotnull then
            var_type_str = var_type_str || ' not null';
        end if;

        insert into var_out_table ("Номер", "Имя столбца", "Атрибуты")
        values (var_row.attnum::text, var_row.attname, 'Type: ' || var_type_str);

        if var_row.description is not null then
            insert into var_out_table ("Номер", "Имя столбца", "Атрибуты")
            values ('', '', 'Comment: ' || var_row.description);
        end if;
    end loop;

    return query
        select * from var_out_table;
end;
$$ language plpgsql;

select * from lab1_print('Заказ');