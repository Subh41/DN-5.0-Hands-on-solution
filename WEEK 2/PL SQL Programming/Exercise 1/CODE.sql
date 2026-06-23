CREATE TABLE customers (
    customer_id NUMBER PRIMARY KEY,
    name VARCHAR2(100),
    age NUMBER,
    balance NUMBER,
    is_vip VARCHAR2(5) DEFAULT 'FALSE',
    current_loan_interest_rate NUMBER
);

CREATE TABLE loans (
    loan_id NUMBER PRIMARY KEY,
    customer_id NUMBER,
    due_date DATE,
    amount NUMBER,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

INSERT INTO customers VALUES (1, 'John Doe', 65, 5000, 'FALSE', 5.0);
INSERT INTO customers VALUES (2, 'Jane Smith', 45, 15000, 'FALSE', 4.5);
INSERT INTO customers VALUES (3, 'Robert Brown', 70, 8000, 'FALSE', 6.0);
INSERT INTO customers VALUES (4, 'Alice Green', 55, 12000, 'FALSE', 5.5);

INSERT INTO loans VALUES (101, 1, ADD_MONTHS(SYSDATE, 1), 10000);
INSERT INTO loans VALUES (102, 2, ADD_MONTHS(SYSDATE, 2), 20000);
INSERT INTO loans VALUES (103, 3, ADD_MONTHS(SYSDATE, 1), 15000);
INSERT INTO loans VALUES (104, 4, ADD_MONTHS(SYSDATE, 3), 5000);

BEGIN
  FOR cust IN (SELECT * FROM customers WHERE age > 60) LOOP
    UPDATE customers
    SET current_loan_interest_rate = current_loan_interest_rate - 1
    WHERE customer_id = cust.customer_id;
    
    DBMS_OUTPUT.PUT_LINE('Applied 1% discount to customer ' || cust.name || 
                         '. New rate: ' || (cust.current_loan_interest_rate - 1) || '%');
  END LOOP;
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('Discount application complete.');
END;
/

BEGIN
  FOR cust IN (SELECT * FROM customers WHERE balance > 10000) LOOP
    UPDATE customers
    SET is_vip = 'TRUE'
    WHERE customer_id = cust.customer_id;
    
    DBMS_OUTPUT.PUT_LINE('Promoted customer ' || cust.name || 
                         ' to VIP status. Balance: $' || cust.balance);
  END LOOP;
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('VIP promotion complete.');
END;
/

BEGIN
  FOR loan_rec IN (
    SELECT l.loan_id, c.name, l.due_date 
    FROM loans l
    JOIN customers c ON l.customer_id = c.customer_id
    WHERE l.due_date BETWEEN SYSDATE AND SYSDATE + 30
  ) LOOP
    DBMS_OUTPUT.PUT_LINE('REMINDER: Customer ' || loan_rec.name || 
                         ' has a loan due on ' || TO_CHAR(loan_rec.due_date, 'DD-MON-YYYY') ||
                         '. Please contact them for payment arrangements.');
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('Reminder process complete.');
END;
/

SELECT name, age, current_loan_interest_rate 
FROM customers 
WHERE age > 60;

SELECT name, balance, is_vip 
FROM customers 
WHERE is_vip = 'TRUE';