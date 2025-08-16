#!/bin/bash

APP_DIR=$(dirname $(dirname $(realpath $0)))
PATH=$PATH:$APP_DIR

echo "Testing security vulnerability fixes..."

# Create test data file
cat > security_vuln_test.txt << 'EOF'
id	name	age	salary
1	Alice	25	50000
2	Bob	30	60000
3	Carl	35	70000
EOF

# Test 1: Code injection prevention - basic expressions
echo "Test 1: Code injection prevention - basic expressions..."
if tsv-filter security_vuln_test.txt 'age > 25' | grep -q "Bob\|Carl"; then
    echo "OK - Basic expressions work safely without code injection"
else
    echo "Failed - Basic expressions failed or security issue exists"
fi

# Test 2: Code injection prevention - complex expressions
echo "Test 2: Code injection prevention - complex expressions..."
if tsv-filter security_vuln_test.txt 'age >= 30 && salary > 55000' | grep -q "Bob\|Carl"; then
    echo "OK - Complex expressions work safely without code injection"
else
    echo "Failed - Complex expressions failed or security issue exists"
fi

# Test 3: Code injection prevention - arithmetic operations
echo "Test 3: Code injection prevention - arithmetic operations..."
if tsv-mutate security_vuln_test.txt 'bonus=salary*0.1' | grep -q "5000\|6000\|7000"; then
    echo "OK - Arithmetic operations work safely without code injection"
else
    echo "Failed - Arithmetic operations failed or security issue exists"
fi

# Test 4: Code injection prevention - string operations
echo "Test 4: Code injection prevention - string operations..."
if tsv-filter security_vuln_test.txt 'name =~ "A"' | grep -q "Alice"; then
    echo "OK - String operations work safely without code injection"
else
    echo "Failed - String operations failed or security issue exists"
fi

# Test 5: Code injection prevention - logical operations
echo "Test 5: Code injection prevention - logical operations..."
if tsv-filter security_vuln_test.txt '!(age < 25)' | grep -q "Bob\|Carl"; then
    echo "OK - Logical operations work safely without code injection"
else
    echo "Failed - Logical operations failed or security issue exists"
fi

# Test 6: Code injection prevention - parentheses expressions
echo "Test 6: Code injection prevention - parentheses expressions..."
if tsv-filter security_vuln_test.txt '(age > 25) && (salary > 55000)' | grep -q "Bob\|Carl"; then
    echo "OK - Parentheses expressions work safely without code injection"
else
    echo "Failed - Parentheses expressions failed or security issue exists"
fi

# Test 7: Code injection prevention - nested expressions
echo "Test 7: Code injection prevention - nested expressions..."
if tsv-filter security_vuln_test.txt '((age > 25) && (salary > 55000)) || (name == "Alice")' | grep -q "Alice\|Bob\|Carl"; then
    echo "OK - Nested expressions work safely without code injection"
else
    echo "Failed - Nested expressions failed or security issue exists"
fi

# Test 8: Code injection prevention - mixed operations
echo "Test 8: Code injection prevention - mixed operations..."
if tsv-mutate security_vuln_test.txt 'result=(age+5)*2-salary/1000' | grep -q "60\|70\|80"; then
    echo "OK - Mixed operations work safely without code injection"
else
    echo "Failed - Mixed operations failed or security issue exists"
fi

# Test 9: Code injection prevention - edge cases
echo "Test 9: Code injection prevention - edge cases..."
if tsv-mutate security_vuln_test.txt 'edge=age+0' | grep -q "25\|30\|35"; then
    echo "OK - Edge cases work safely without code injection"
else
    echo "Failed - Edge cases failed or security issue exists"
fi

# Test 10: Code injection prevention - error handling
echo "Test 10: Code injection prevention - error handling..."
if tsv-filter security_vuln_test.txt 'invalid_expression' 2>&1 | grep -q "Error: Unknown variable"; then
    echo "OK - Error handling works safely without code injection"
else
    echo "Failed - Error handling failed or security issue exists"
fi

# Test 11: Code injection prevention - division by zero protection
echo "Test 11: Code injection prevention - division by zero protection..."
if tsv-mutate security_vuln_test.txt 'result=age/0' 2>&1 | grep -q "Error: Division by zero"; then
    echo "OK - Division by zero protection works safely"
else
    echo "Failed - Division by zero protection failed or security issue exists"
fi

# Test 12: Code injection prevention - modulo by zero protection
echo "Test 12: Code injection prevention - modulo by zero protection..."
if tsv-mutate security_vuln_test.txt 'result=age%0' 2>&1 | grep -q "Error: Modulo by zero"; then
    echo "OK - Modulo by zero protection works safely"
else
    echo "Failed - Modulo by zero protection failed or security issue exists"
fi

# Test 13: Code injection prevention - malicious expression detection
echo "Test 13: Code injection prevention - malicious expression detection..."
if tsv-filter security_vuln_test.txt 'system("rm -rf /")' 2>&1 | grep -q "Error"; then
    echo "OK - Malicious expressions are properly rejected"
else
    echo "Failed - Malicious expressions not properly handled"
fi

# Test 14: Code injection prevention - eval function protection
echo "Test 14: Code injection prevention - eval function protection..."
if tsv-mutate security_vuln_test.txt 'result=eval("1+1")' 2>&1 | grep -q "Error"; then
    echo "OK - Eval function calls are properly rejected"
else
    echo "Failed - Eval function calls not properly handled"
fi

# Test 15: Code injection prevention - shell command injection
echo "Test 15: Code injection prevention - shell command injection..."
if tsv-filter security_vuln_test.txt '`ls`' 2>&1 | grep -q "Error"; then
    echo "OK - Shell command injection attempts are properly rejected"
else
    echo "Failed - Shell command injection attempts not properly handled"
fi

echo "Security vulnerability testing completed."
rm -f security_vuln_test.txt
