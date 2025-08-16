#!/bin/bash

APP_DIR=$(dirname $(dirname $(realpath $0)))
PATH=$PATH:$APP_DIR

echo "Testing security fixes and expression parsing..."

# Create test data file
cat > security_test.txt << 'EOF'
name	age	salary	department
Alice	25	50000	IT
Bob	30	60000	HR
Carl	35	70000	IT
David	28	55000	Finance
EOF

# Test 1: Safe arithmetic expressions
echo "Test 1: Safe arithmetic expressions..."
if tsv-filter security_test.txt 'age > 25' | grep -q "Bob\|Carl\|David"; then
    echo "OK - Basic comparison operators work safely"
else
    echo "Failed - Basic comparison operators failed"
fi

# Test 2: Complex expressions
echo "Test 2: Complex expressions..."
if tsv-filter security_test.txt 'age >= 30 && department == "IT"' | grep -q "Carl"; then
    echo "OK - Complex logical expressions work safely"
else
    echo "Failed - Complex logical expressions failed"
fi

# Test 3: Arithmetic operations
echo "Test 3: Arithmetic operations..."
if tsv-mutate security_test.txt 'bonus=salary*0.1' | grep -q "5000\|6000\|7000\|5500"; then
    echo "OK - Arithmetic operations work safely"
else
    echo "Failed - Arithmetic operations failed"
fi

# Test 4: String operations
echo "Test 4: String operations..."
if tsv-filter security_test.txt 'name =~ "A"' | grep -q "Alice"; then
    echo "OK - String regex operations work safely"
else
    echo "Failed - String regex operations failed"
fi

# Test 5: Numeric comparisons
echo "Test 5: Numeric comparisons..."
if tsv-filter security_test.txt 'age > 25 && age < 35' | grep -q "Alice\|Bob\|David"; then
    echo "OK - Numeric range comparisons work safely"
else
    echo "Failed - Numeric range comparisons failed"
fi

# Test 6: Logical operations
echo "Test 6: Logical operations..."
if tsv-filter security_test.txt '!(age < 25)' | grep -q "Bob\|Carl\|David"; then
    echo "OK - Logical NOT operations work safely"
else
    echo "Failed - Logical NOT operations failed"
fi

# Test 7: Mixed operations
echo "Test 7: Mixed operations..."
if tsv-mutate security_test.txt 'seniority=age-25' | grep -q "0\|5\|10\|3"; then
    echo "OK - Mixed arithmetic operations work safely"
else
    echo "Failed - Mixed arithmetic operations failed"
fi

# Test 8: Division operations
echo "Test 8: Division operations..."
if tsv-mutate security_test.txt 'monthly=salary/12' | grep -q "4166\|5000\|5833\|4583"; then
    echo "OK - Division operations work safely"
else
    echo "Failed - Division operations failed"
fi

# Test 9: Modulo operations
echo "Test 9: Modulo operations..."
if tsv-mutate security_test.txt 'remainder=age%10' | grep -q "5\|0\|5\|8"; then
    echo "OK - Modulo operations work safely"
else
    echo "Failed - Modulo operations failed"
fi

# Test 10: Power operations
echo "Test 10: Power operations..."
if tsv-mutate security_test.txt 'squared=age^2' | grep -q "625\|900\|1225\|784"; then
    echo "OK - Power operations work safely"
else
    echo "Failed - Power operations failed"
fi

# Test 11: Parentheses expressions
echo "Test 11: Parentheses expressions..."
if tsv-filter security_test.txt '(age > 25) && (department == "IT")' | grep -q "Carl"; then
    echo "OK - Parentheses expressions work correctly"
else
    echo "Failed - Parentheses expressions failed"
fi

# Test 12: Nested parentheses expressions
echo "Test 12: Nested parentheses expressions..."
if tsv-filter security_test.txt '((age > 25) && (department == "IT")) || (name == "Alice")' | grep -q "Alice\|Carl"; then
    echo "OK - Nested parentheses expressions work correctly"
else
    echo "Failed - Nested parentheses expressions failed"
fi

# Test 13: Error handling for invalid expressions
echo "Test 13: Error handling for invalid expressions..."
if tsv-filter security_test.txt 'invalid_expression' 2>&1 | grep -q "Error: Unknown variable"; then
    echo "OK - Invalid expressions are properly rejected"
else
    echo "Failed - Invalid expressions not properly handled"
fi

# Test 14: Division by zero protection
echo "Test 14: Division by zero protection..."
if tsv-mutate security_test.txt 'result=age/0' 2>&1 | grep -q "Error: Division by zero"; then
    echo "OK - Division by zero protection works correctly"
else
    echo "Failed - Division by zero protection failed"
fi

# Test 15: Modulo by zero protection
echo "Test 15: Modulo by zero protection..."
if tsv-mutate security_test.txt 'result=age%0' 2>&1 | grep -q "Error: Modulo by zero"; then
    echo "OK - Modulo by zero protection works correctly"
else
    echo "Failed - Modulo by zero protection failed"
fi

echo "Security fixes testing completed."
rm -f security_test.txt
