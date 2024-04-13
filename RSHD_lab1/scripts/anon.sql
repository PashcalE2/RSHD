do $$
declare
arg_target_table text = 'Заказ';
    var_row record;
    var_column_max_len record;
    var_type_str text;
    var_num_column text = 'Номер';
    var_name_column text = 'Имя столбца';
    var_description_column text = 'Атрибуты';
    var_format_str text;
begin
    drop table if exists var_out_table;

    create temp table if not exists var_out_table (
            "Номер" text,
            "Имя столбца" text,
            "Атрибуты" text
    );

    for var_row in select attnum, attname, typname, atttypmod, attnotnull, description from pg_catalog.pg_attribute pga
        inner join pg_catalog.pg_type pgt on pga.atttypid = pgt.oid
        left join (select * from pg_catalog.pg_description where objoid = arg_target_table::regclass) as pgd on pga.attnum = pgd.objsubid
        where attrelid = arg_target_table::regclass and attnum >= 1
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
            values ('*', '*', 'Comment: ' || var_row.description);
        end if;
    end loop;

    select max(length("Номер")) as num, max(length("Имя столбца")) as name, max(length("Атрибуты")) as description from var_out_table
    into var_column_max_len;

    if var_column_max_len.num < length(var_num_column) then
        var_column_max_len.num = length(var_num_column);
    end if;

    if var_column_max_len.name < length(var_name_column) then
        var_column_max_len.name = length(var_name_column);
    end if;

    if var_column_max_len.description < length(var_description_column) then
        var_column_max_len.description = length(var_description_column);
    end if;

    var_format_str = format('%%-%ss | %%%ss | %%%ss', var_column_max_len.num, var_column_max_len.name, var_column_max_len.description);

    raise notice '%', format(var_format_str, var_num_column, var_name_column, var_description_column);
    raise notice '%', format('%s-+-%s-+-%s', repeat('-', var_column_max_len.num), repeat('-', var_column_max_len.name), repeat('-', var_column_max_len.description));

    for var_row in select "Номер" as num, "Имя столбца" as name, "Атрибуты" as description from var_out_table loop
        raise notice '%', format(var_format_str, var_row.num, var_row.name, var_row.description);
    end loop;
end;
$$ language plpgsql;


select * from information_schema.columns;