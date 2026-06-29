CREATE TABLE savings_accounts (
    account_id NUMBER PRIMARY KEY,
    customer_id NUMBER,
    balance NUMBER(10,2),
    interest_rate NUMBER(5,2) DEFAULT 0.01
);

CREATE TABLE employees (
    employee_id NUMBER PRIMARY KEY,
    name VARCHAR2(100),
    department VARCHAR2(50),
    salary NUMBER(10,2),
    performance_rating NUMBER(2,1)
);

CREATE TABLE accounts (
    account_id NUMBER PRIMARY KEY,
    customer_id NUMBER,
    account_type VARCHAR2(20),
    balance NUMBER(10,2)
);

INSERT INTO savings_accounts VALUES (101, 1, 5000.00, 0.01);
INSERT INTO savings_accounts VALUES (102, 2, 10000.00, 0.01);
INSERT INTO savings_accounts VALUES (103, 3, 7500.00, 0.01);

INSERT INTO employees VALUES (1, 'John Smith', 'Loans', 50000.00, 4.5);
INSERT INTO employees VALUES (2, 'Sarah Johnson', 'Customer Service', 45000.00, 3.8);
INSERT INTO employees VALUES (3, 'Michael Brown', 'Loans', 60000.00, 4.2);

INSERT INTO accounts VALUES (201, 1, 'Checking', 2500.00);
INSERT INTO accounts VALUES (202, 1, 'Savings', 5000.00);
INSERT INTO accounts VALUES (203, 2, 'Checking', 3000.00);
INSERT INTO accounts VALUES (204, 2, 'Savings', 10000.00);

CREATE OR REPLACE PROCEDURE ProcessMonthlyInterest AS
BEGIN
  UPDATE savings_accounts
  SET balance = balance + (balance * interest_rate);
  
  DBMS_OUTPUT.PUT_LINE('Monthly interest processed for all savings accounts.');
  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error processing monthly interest: ' || SQLERRM);
    ROLLBACK;
END ProcessMonthlyInterest;
/


BEGIN
  ProcessMonthlyInterest();
END;
/


SELECT * FROM savings_accounts;

CREATE OR REPLACE PROCEDURE UpdateEmployeeBonus(
    p_department IN VARCHAR2,
    p_bonus_percentage IN NUMBER
) AS
BEGIN
  UPDATE employees
  SET salary = salary * (1 + p_bonus_percentage/100)
  WHERE department = p_department;
  
  DBMS_OUTPUT.PUT_LINE('Bonus applied to ' || SQL%ROWCOUNT || 
                      ' employees in ' || p_department || ' department.');
  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error updating employee bonuses: ' || SQLERRM);
    ROLLBACK;
END UpdateEmployeeBonus;
/

-- Execute the procedure with 10% bonus for Loans department
BEGIN
  UpdateEmployeeBonus('Loans', 10);
END;
/

-- Verify results
SELECT * FROM employees WHERE department = 'Loans';

CREATE OR REPLACE PROCEDURE TransferFunds(
    p_from_account IN NUMBER,
    p_to_account IN NUMBER,
    p_amount IN NUMBER
) AS
  v_from_balance NUMBER;
  v_to_account_exists NUMBER;
BEGIN
  -- Check if source account has sufficient balance
  SELECT balance INTO v_from_balance
  FROM accounts
  WHERE account_id = p_from_account
  FOR UPDATE;
  
  IF v_from_balance < p_amount THEN
    RAISE_APPLICATION_ERROR(-20001, 'Insufficient funds in source account');
  END IF;
  
  -- Check if destination account exists
  SELECT COUNT(*) INTO v_to_account_exists
  FROM accounts
  WHERE account_id = p_to_account;
  
  IF v_to_account_exists = 0 THEN
    RAISE_APPLICATION_ERROR(-20002, 'Destination account does not exist');
  END IF;
  
  -- Perform the transfer
  UPDATE accounts
  SET balance = balance - p_amount
  WHERE account_id = p_from_account;
  
  UPDATE accounts
  SET balance = balance + p_amount
  WHERE account_id = p_to_account;
  
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('Successfully transferred $' || p_amount || 
                      ' from account ' || p_from_account || 
                      ' to account ' || p_to_account);
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Transfer failed: ' || SQLERRM);
END TransferFunds;
/

-- Execute the procedure (transfer $500 from account 201 to 202)
BEGIN
  TransferFunds(201, 202, 500);
END;
/

-- Verify results
SELECT * FROM accounts WHERE account_id IN (201, 202);

SELECT account_id, balance FROM savings_accounts;

SELECT employee_id, name, salary, department 
FROM employees 
WHERE department = 'Loans';

SELECT account_id, balance 
FROM accounts 
WHERE account_id IN (201, 202);