create table DIM_DATES (
    DAY_ID date,
    DAY_END_DATE date,
    DAY_TIME_SPAN number,
    DAY_DESCRIPTION varchar2(60),
    DAY_OF_MONTH number,
    DAY_OF_QUARTER number,
    DAY_OF_YEAR number,
    MONTH_ID varchar2(60),
    MONTH_END_DATE date,
    MONTH_TIME_SPAN number,
    MONTH_DESCRIPTION varchar2(60),
    MONTH_OF_QUARTER number,
    MONTH_OF_YEAR number,
    QUARTER_ID varchar2(60),
    QUARTER_END_DATE date,
    QUARTER_TIME_SPAN number,
    QUARTER_DESCRIPTION varchar2(60),
    QUARTER_OF_YEAR NUMBER,
    HALF_YEAR_ID varchar2(60),
    HALF_YEAR_END_DATE date,
    HALF_YEAR_TIME_SPAN number,
    HALF_YEAR_DESCRIPTION varchar2(60),
    YEAR_ID VARCHAR2(60),
    YEAR_END_DATE date,
    YEAR_TIME_SPAN number,
    YEAR_DESCRIPTION varchar2(60),
    TOP_ID VARCHAR2(60),
    TOP_END_DATE date,
    TOP_TIME_SPAN number,
    TOP_DESCRIPTION varchar2(60)
);
insert into DIM_DATES
  select distinct
    dt DAY_ID,
    dt DAY_END_DATE,
    1 DAY_TIME_SPAN,
    to_char(dt, 'dd-mm-yyyy') DAY_DESCRIPTION,
    dt - (month_start_date) + 1 DAY_OF_MONTH,
    dt - quarter_start_date + 1 DAY_OF_QUARTER,
    dt - year_start_date + 1 DAY_OF_YEAR,
    to_char(month_start_date, 'MON-yyyy') MONTH_ID,
    last_day(month_start_date) MONTH_END_DATE,
    add_months(month_start_date, 1) - (month_start_date) MONTH_TIME_SPAN,
    to_char(month_start_date, 'MON-yyyy') MONTH_DESCRIPTION,
    trunc(months_between(month_start_date, quarter_start_date) + 1) MONTH_OF_QUARTER,
    trunc(months_Between(month_start_date, year_start_date) + 1) MONTH_OF_YEAR,
    'CAL'||extract(year from quarter_start_date) || '-' || 'Q' || trunc((months_between(quarter_start_date, year_start_date) + 3)/ 3) QUARTER_ID,
    add_months(quarter_start_date - 1, 3) QUARTER_END_DATE,
    add_months(quarter_start_date - 1, 3) - quarter_start_date + 1 QUARTER_TIME_SPAN,
    'calendar quarter ' || trunc((months_between(quarter_start_date, year_start_date) + 3)/ 3) QUARTER_DESCRIPTION,
    trunc(extract(month from quarter_start_date)/3) + 1 QUARTER_OF_YEAR,
    'CAL'||extract(year from year_start_date)|| '-' || 'H' || trunc((months_between(half_year_start_date, year_start_date) + 6)/ 6) HALF_YEAR_ID,
    add_months(year_start_date - 1, 6) HALF_YEAR_END_DATE,
    add_months(year_start_date - 1, 6) - year_start_date + 1 HALF_YEAR_TIME_SPAN,
    to_char(year_start_date , 'yyyy') HALF_YEAR_DESCRIPTION,
    'CAL'||extract(year from year_start_date) YEAR_ID,
    last_day(add_months(year_start_date, 11)) YEAR_END_DATE,
    last_day(add_months(year_start_date, 11)) - year_start_date + 1 YEAR_TIME_SPAN,
    'calendar year ' || extract(year from year_start_date) YEAR_DESCRIPTION,
    'CAL'||'TOP' TOP_ID,
    time_end_date TOP_END_DATE,
    time_end_date - time_start_date TOP_TIME_SPAN,
    'calendar top' TOP_DESCRIPTION
  from 
    (SELECT
          dt
         ,dt - (extract(day from dt) - 1) AS month_start_date
         ,add_months(to_date('01-01-1970', 'dd-mm-yyyy'), trunc(months_between(dt, to_date('01-01-1970', 'dd-mm-yyyy') ) / 3) * 3) AS quarter_start_date
         ,add_months(to_date('01-01-1970', 'dd-mm-yyyy'), trunc(months_between(dt, to_date('01-01-1970', 'dd-mm-yyyy') ) / 6) * 6) AS half_year_start_date
         ,add_months(to_date('01-01-1970', 'dd-mm-yyyy'), trunc(months_between(dt, to_date('01-01-1970', 'dd-mm-yyyy') ) / 12) * 12) AS year_start_date
         ,to_date('01-01-1970', 'dd-mm-yyyy') AS time_start_date
         ,add_months(to_date('01-01-1970', 'dd-mm-yyyy'), 60 * 12) as time_end_date
         FROM (SELECT 
             (to_date('01-01-1970', 'dd-mm-yyyy')) + numtodsinterval((LEVEL - 1), 'day') AS dt 
             FROM DUAL 
                 CONNECT BY (LEVEL - 1) <= (add_months(to_date('01-01-1970', 'dd-mm-yyyy'), 60 * 12) - to_date('01-01-1970', 'dd-mm-yyyy') - 1)
              )

         )
  order by dt;
