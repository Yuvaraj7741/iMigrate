create or replace procedure orac()
 returns string
 language javascript
 as
 $$
 
 try
 {
 
     var sql_command ;
	 
	 var cur_SQL_command = 'SELECT emp_id FROM emp;';
	 var stmt = snowflake.createStatement ({sqlText: cur_SQL_command}); 
	 var test = snowflake.execute(stmt);
	 
	 idwUnkwn_TYPE lv_emp_id_tbl IS TABLE OF emp.emp_id%type;
	 
	 var lv_emp_id = lv_emp_id_tbl;
	 
	 var v_record_count = 0;
	 var v_qry;
	  
	 
	 while(test.next())
	 {
	    idwUnkwn_FETCH test BULK COLLECT INTO lv_emp_id LIMIT 100;
		
	    for( i = lv_emp_id.FIRST ; i < lv_emp_id.LAST ; i++)
		{
			sql_command = "UPDATE    empSET   salary = salary * 1.5 WHERE    emp_id = idwUnkwn_lv_emp_id(i) ;               "
	
			snowflake.execute ( {sqlText: sql_command});
		}
	 }
	
	 
	 sql_command = "INSERT INTO    DEPT(   DEPT_ID,   DEPT_NAME,   DEPT_GRP,   DEPT_DESC,   DEPT_TYPE) SELECT    DID,    DNAME,    CASE WHEN REGEXP_INSTR(DGRP,'G1')> 0 THEN 'Group 1' WHEN REGEXP_INSTR(DGRP,'G2')> 0 THEN 'Group 2' WHEN REGEXP_INSTR(DGRP,'G3')> 0 THEN 'Group 3' ELSE 'Group 4' END as DEPT_GRP,    REGEXP_REPLACE(TEXT,'[^\a-zA-Z0-9]',' ') as DEPT_DESC,    DECODE(DTYPE,'A','HR','B','DEVELOPMENT','C','TESTING','MISC') as DEPT_TYPE FROM    DEPTMSTR ;               "
	
	 snowflake.execute ( {sqlText: sql_command});
	 
		 
	 var v_record_count = SQL%ROWCOUNT;
	 
	 idwUnkwn_DBMS_OUTPUT.PUT_LINE('Records Inserted..'||v_record_count);
	 
	 var v_qry = 'UPDATE emp SET emp_type = ''TRAINEE'', emp_grp = ''TEST'',emp_location = ''ALL'',WHERE 1=1' ;
	 
	 snowflake.execute ( {sqlText: v_qry});
	 
	 var v_record_count = SQL%ROWCOUNT;
	 
	 idwUnkwn_DBMS_OUTPUT.PUT_LINE('Records Updated..'||v_record_count);
	 
	 sql_command = "INSERT INTO    TEST_MARKETING(   ename,   sal,   erank) SELECT    employee_name,    salary,    idwUnkwn_RANK()OVER(PARTITION BY department ORDER BY salary) as erank FROM    emp WHERE    department = 'MARKETING' ;               "

	 snowflake.execute ( {sqlText: sql_command});
	 
	 
	 
 }   
 catch(err)
 {
     WHEN OTHERS  THEN
     NULL;
	 
	 return 'Failed : ' + err;
 }
 $$
 ;