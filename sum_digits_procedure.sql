CREATE OR REPLACE PROCEDURE sum_digits (
    p_table_name IN VARCHAR2
) IS

    p_cur   INTEGER;--курсор
    p_column_value VARCHAR2(100);--значения таблицы, с которыми будем работать
    p_sum          NUMBER := 0;--сумма цифр
    p_col_cnt      INTEGER;--количество столбцов
    p_temp INTEGER;
    p_rec_tab      dbms_sql.desc_tab;--коллекция с информацией о столбцах
    p_query        VARCHAR2(4000) := 'SELECT * FROM ' || p_table_name;--запрос
BEGIN
--открываем курсор
    p_cur := dbms_sql.open_cursor;
    --разбор запроса
    dbms_sql.parse(p_cur, p_query, dbms_sql.native);
    --получаем информацию о столбцах
    dbms_sql.describe_columns(p_cur, p_col_cnt, p_rec_tab);
    --записываем значения
    FOR i IN 1..p_col_cnt LOOP
        dbms_sql.define_column(p_cur, i, p_column_value, 100);
    END LOOP;

    p_temp:=dbms_sql.execute(p_cur);
    LOOP
        EXIT WHEN dbms_sql.fetch_rows(p_cur) = 0;
        FOR i IN 1..p_col_cnt LOOP
        --если значение типа NUMBER
            IF p_rec_tab(i).col_type = 2 THEN
            --получаем значение
                dbms_sql.column_value(p_cur, i, p_column_value);
                IF p_column_value IS NOT NULL THEN
                --складываем каждую цифру в числе
                    FOR i IN 1..length(to_char(p_column_value)) LOOP
                        IF substr(to_char(p_column_value),
                                  i,
                                  1) BETWEEN '0' AND '9' THEN
                            p_sum := p_sum + TO_NUMBER ( substr(to_char(p_column_value),
                                                                i,
                                                                1) );

                        END IF;
                    END LOOP;

                END IF;
            --если значение типа VARCHAR2
            ELSIF p_rec_tab(i).col_type = 1 THEN
            --получаем значение
                dbms_sql.column_value(p_cur, i, p_column_value);
                IF p_column_value IS NOT NULL THEN
                --складываем каждую цифру в числе
                    FOR j IN 1..length(p_column_value) LOOP
                        IF substr(p_column_value, j, 1) BETWEEN '0' AND '9' THEN
                            p_sum := p_sum + TO_NUMBER ( substr(p_column_value, j, 1) );
                        END IF;
                    END LOOP;

                END IF;
                
            --если значение типа DATE
            ELSIF p_rec_tab(i).col_type = 12 THEN
            --получаем значение
                dbms_sql.column_value(p_cur, i, p_column_value);
                IF p_column_value IS NOT NULL THEN
                --складываем каждую цифру в дне
                    FOR j IN 1..length(to_char(TO_DATE(p_column_value, 'dd.mm.RRRR'), 'DD')) LOOP
                        IF substr(to_char(TO_DATE(p_column_value, 'dd.mm.RRRR'),
                                          'DD'),
                                  j,
                                  1) BETWEEN '0' AND '9' THEN
                            p_sum := p_sum + TO_NUMBER ( substr(to_char(TO_DATE(p_column_value, 'dd.mm.RRRR'),
                                                                        'DD'),
                                                                j,
                                                                1) );

                        END IF;
                    END LOOP;
                    --складываем каждую цифру в месяце
                    FOR j IN 1..length(to_char(TO_DATE(p_column_value, 'dd.mm.RRRR'), 'MM')) LOOP
                        IF substr(to_char(TO_DATE(p_column_value, 'dd.mm.RRRR'),
                                          'MM'),
                                  j,
                                  1) BETWEEN '0' AND '9' THEN
                            p_sum := p_sum + TO_NUMBER ( substr(to_char(TO_DATE(p_column_value, 'dd.mm.RRRR'),
                                                                        'MM'),
                                                                j,
                                                                1) );

                        END IF;
                    END LOOP;
                    --складываем каждую цифру в годе
                    FOR j IN 1..length(to_char(TO_DATE(p_column_value, 'dd.mm.RRRR'), 'RRRR')) LOOP
                        IF substr(to_char(TO_DATE(p_column_value, 'dd.mm.RRRR'),
                                          'RRRR'),
                                  j,
                                  1) BETWEEN '0' AND '9' THEN
                            p_sum := p_sum + TO_NUMBER ( substr(to_char(TO_DATE(p_column_value, 'dd.mm.RRRR'),
                                                                        'RRRR'),
                                                                j,
                                                                1) );

                        END IF;
                    END LOOP;

                END IF;

            END IF;
        END LOOP;

    END LOOP;
--закрываем курсор и выводим результат
    dbms_sql.close_cursor(p_cur);
    dbms_output.put_line('Сумма чисел в таблице '
                         || p_table_name
                         || ' равна '
                         || p_sum);
END;
/
