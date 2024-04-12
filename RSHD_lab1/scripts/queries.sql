select attnum, attname, typname, atttypmod, attnotnull, description from pg_catalog.pg_attribute pga
inner join pg_catalog.pg_type pgt on pga.atttypid = pgt.oid
left join (select * from pg_catalog.pg_description where objoid = 'Н_УЧЕНИКИ'::regclass) as pgd on pga.attnum = pgd.objsubid
where attrelid = 'Н_УЧЕНИКИ'::regclass and attnum >= 1
order by attnum;

do $$
declare
    var_имя_таблицы text = 'Н_ЛЮДИ';
    var_num_column_name text = 'Номер';
    var_name_column_name text = 'Имя столбца';
    var_attr_column_name text = 'Атрибуты';
    var_max_spaces record;
    var_line_format text;
    var_row record;
    var_type_str text;
begin
    select max(length('' || attnum)) as num, max(length(attname)) as name, max(length(description)) as description from pg_catalog.pg_attribute pga
        inner join pg_catalog.pg_type pgt on pga.atttypid = pgt.oid
        left join (select * from pg_catalog.pg_description where objoid = var_имя_таблицы::regclass) as pgd on pga.attnum = pgd.objsubid
        where attrelid = var_имя_таблицы::regclass and attnum >= 1
    into var_max_spaces;

    if var_max_spaces.num < length(var_num_column_name) then
        var_max_spaces.num = length(var_num_column_name);
    end if;

    if var_max_spaces.name < length(var_name_column_name) then
        var_max_spaces.name = length(var_name_column_name);
    end if;

    var_line_format = format('%%-%ss | %%%ss | %%s', var_max_spaces.num, var_max_spaces.name);

    raise notice '%', format(var_line_format, var_num_column_name, var_name_column_name, var_attr_column_name);
    raise notice '%', format('%s-+-%s-+-%s', repeat('-', var_max_spaces.num), repeat('-', var_max_spaces.name), repeat('-', var_max_spaces.description + 9));

    for var_row in select attnum, attname, typname, atttypmod, attnotnull, description from pg_catalog.pg_attribute pga
        inner join pg_catalog.pg_type pgt on pga.atttypid = pgt.oid
        left join (select * from pg_catalog.pg_description where objoid = var_имя_таблицы::regclass) as pgd on pga.attnum = pgd.objsubid
        where attrelid = var_имя_таблицы::regclass and attnum >= 1
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

        raise notice '%', format(var_line_format, var_row.attnum, var_row.attname, 'Type: ' || var_type_str);

        if var_row.description is not null then
            raise notice '%', format(var_line_format, '*', '*', 'Comment: ' || var_row.description);
        end if;
    end loop;
end;
$$ language plpgsql;


select * from pg_catalog.pg_attribute
where attrelid = 'Н_УЧЕНИКИ'::regclass and attnum >= 1
order by attnum;

select * from pg_catalog.pg_type;

select * from pg_catalog.pg_constraint;

select * from pg_catalog.pg_depend;

select * from pg_catalog.pg_class;

select * from pg_catalog.pg_description;

select * from information_schema.columns;

select * from information_schema.constraint_column_usage;