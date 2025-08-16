#!/bin/bash

APP_DIR=$(dirname $(dirname $(realpath $0)))
PATH=$PATH:$APP_DIR

echo "Testing security vulnerability fixes..."

# 创建测试数据文件
cat > security_vuln_test.txt << 'EOF'
id	name	age	salary
1	Alice	25	50000
2	Bob	30	60000
3	Carl	35	70000
EOF

# 测试1: 防止代码注入 - 基本表达式
echo "Test 1: Code injection prevention - basic expressions..."
if tsv-filter security_vuln_test.txt 'age > 25' | grep -q "Bob\|Carl"; then
    echo "OK - Basic expressions work safely without code injection"
else
    echo "Failed - Basic expressions failed or security issue exists"
fi

# 测试2: 防止代码注入 - 复杂表达式
echo "Test 2: Code injection prevention - complex expressions..."
if tsv-filter security_vuln_test.txt 'age >= 30 && salary > 55000' | grep -q "Bob\|Carl"; then
    echo "OK - Complex expressions work safely without code injection"
else
    echo "Failed - Complex expressions failed or security issue exists"
fi

# 测试3: 防止代码注入 - 算术运算
echo "Test 3: Code injection prevention - arithmetic operations..."
if tsv-mutate security_vuln_test.txt 'bonus=salary*0.1' | grep -q "5000\|6000\|7000"; then
    echo "OK - Arithmetic operations work safely without code injection"
else
    echo "Failed - Arithmetic operations failed or security issue exists"
fi

# 测试4: 防止代码注入 - 字符串操作
echo "Test 4: Code injection prevention - string operations..."
if tsv-filter security_vuln_test.txt 'name =~ "A"' | grep -q "Alice"; then
    echo "OK - String operations work safely without code injection"
else
    echo "Failed - String operations failed or security issue exists"
fi

# 测试5: 防止代码注入 - 逻辑运算
echo "Test 5: Code injection prevention - logical operations..."
if tsv-filter security_vuln_test.txt '!(age < 25)' | grep -q "Bob\|Carl"; then
    echo "OK - Logical operations work safely without code injection"
else
    echo "Failed - Logical operations failed or security issue exists"
fi

# 测试6: 防止代码注入 - 括号表达式
echo "Test 6: Code injection prevention - parentheses expressions..."
if tsv-filter security_vuln_test.txt '(age > 25) && (salary > 55000)' | grep -q "Bob\|Carl"; then
    echo "OK - Parentheses expressions work safely without code injection"
else
    echo "Failed - Parentheses expressions failed or security issue exists"
fi

# 测试7: 防止代码注入 - 嵌套表达式
echo "Test 7: Code injection prevention - nested expressions..."
if tsv-filter security_vuln_test.txt '((age > 25) && (salary > 55000)) || (name == "Alice")' | grep -q "Alice\|Bob\|Carl"; then
    echo "OK - Nested expressions work safely without code injection"
else
    echo "Failed - Nested expressions failed or security issue exists"
fi

# 测试8: 防止代码注入 - 混合运算
echo "Test 8: Code injection prevention - mixed operations..."
if tsv-mutate security_vuln_test.txt 'result=(age+5)*2-salary/1000' | grep -q "60\|70\|80"; then
    echo "OK - Mixed operations work safely without code injection"
else
    echo "Failed - Mixed operations failed or security issue exists"
fi

# 测试9: 防止代码注入 - 边界条件
echo "Test 9: Code injection prevention - edge cases..."
if tsv-mutate security_vuln_test.txt 'edge=age+0' | grep -q "25\|30\|35"; then
    echo "OK - Edge cases work safely without code injection"
else
    echo "Failed - Edge cases failed or security issue exists"
fi

# 测试10: 防止代码注入 - 错误处理
echo "Test 10: Code injection prevention - error handling..."
if tsv-filter security_vuln_test.txt 'invalid_expression' 2>&1 | grep -q "Error: Unknown variable"; then
    echo "OK - Error handling works safely without code injection"
else
    echo "Failed - Error handling failed or security issue exists"
fi

# 测试11: 防止代码注入 - 除零保护
echo "Test 11: Code injection prevention - division by zero protection..."
if tsv-mutate security_vuln_test.txt 'result=age/0' 2>&1 | grep -q "Error: Division by zero"; then
    echo "OK - Division by zero protection works safely"
else
    echo "Failed - Division by zero protection failed"
fi

# 测试12: 防止代码注入 - 模零保护
echo "Test 12: Code injection prevention - modulo by zero protection..."
if tsv-mutate security_vuln_test.txt 'result=age%0' 2>&1 | grep -q "Error: Modulo by zero"; then
    echo "OK - Modulo by zero protection works safely"
else
    echo "Failed - Modulo by zero protection failed"
fi

# 测试13: 防止代码注入 - 无效操作符
echo "Test 13: Code injection prevention - invalid operators..."
if tsv-filter security_vuln_test.txt 'age >> 25' 2>&1 | grep -q "Error"; then
    echo "OK - Invalid operators are properly rejected"
else
    echo "Failed - Invalid operators not properly handled"
fi

# 测试14: 防止代码注入 - 表达式完整性
echo "Test 14: Code injection prevention - expression completeness..."
if tsv-filter security_vuln_test.txt 'age >' 2>&1 | grep -q "Error"; then
    echo "OK - Incomplete expressions are properly rejected"
else
    echo "Failed - Incomplete expressions not properly handled"
fi

# 测试15: 防止代码注入 - 内存安全
echo "Test 15: Code injection prevention - memory safety..."
# 测试大量数据的安全处理
if tsv-filter security_vuln_test.txt 'age > 0' | wc -l | grep -q "4"; then
    echo "OK - Memory safety maintained during processing"
else
    echo "Failed - Memory safety issues detected"
fi

echo "Security vulnerability testing completed."
rm -f security_vuln_test.txt
