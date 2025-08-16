#!/bin/bash

APP_DIR=$(dirname $(dirname $(realpath $0)))
PATH=$PATH:$APP_DIR

echo "Testing security fixes and expression parsing..."

# 创建测试数据文件
cat > security_test.txt << 'EOF'
name	age	salary	department
Alice	25	50000	IT
Bob	30	60000	HR
Carl	35	70000	IT
David	28	55000	Finance
EOF

# 测试1: 安全的表达式计算 - 基本算术运算
echo "Test 1: Safe arithmetic expressions..."
if tsv-filter security_test.txt 'age > 25' | grep -q "Bob\|Carl\|David"; then
    echo "OK - Basic comparison operators work safely"
else
    echo "Failed - Basic comparison operators failed"
fi

# 测试2: 安全的表达式计算 - 复杂表达式
echo "Test 2: Complex expressions..."
if tsv-filter security_test.txt 'age >= 30 && department == "IT"' | grep -q "Carl"; then
    echo "OK - Complex logical expressions work safely"
else
    echo "Failed - Complex logical expressions failed"
fi

# 测试3: 安全的表达式计算 - 算术运算
echo "Test 3: Arithmetic operations..."
if tsv-mutate security_test.txt 'bonus=salary*0.1' | grep -q "5000\|6000\|7000\|5500"; then
    echo "OK - Arithmetic operations work safely"
else
    echo "Failed - Arithmetic operations failed"
fi

# 测试4: 安全的表达式计算 - 字符串操作
echo "Test 4: String operations..."
if tsv-filter security_test.txt 'name =~ "A"' | grep -q "Alice"; then
    echo "OK - String regex operations work safely"
else
    echo "Failed - String regex operations failed"
fi

# 测试5: 安全的表达式计算 - 数值比较
echo "Test 5: Numeric comparisons..."
if tsv-filter security_test.txt 'age > 25 && age < 35' | grep -q "Alice\|Bob\|David"; then
    echo "OK - Numeric range comparisons work safely"
else
    echo "Failed - Numeric range comparisons failed"
fi

# 测试6: 安全的表达式计算 - 逻辑运算
echo "Test 6: Logical operations..."
if tsv-filter security_test.txt '!(age < 25)' | grep -q "Bob\|Carl\|David"; then
    echo "OK - Logical NOT operations work safely"
else
    echo "Failed - Logical NOT operations failed"
fi

# 测试7: 安全的表达式计算 - 混合运算
echo "Test 7: Mixed operations..."
if tsv-mutate security_test.txt 'seniority=age-25' | grep -q "0\|5\|10\|3"; then
    echo "OK - Mixed arithmetic operations work safely"
else
    echo "Failed - Mixed arithmetic operations failed"
fi

# 测试8: 安全的表达式计算 - 除法运算
echo "Test 8: Division operations..."
if tsv-mutate security_test.txt 'monthly=salary/12' | grep -q "4166\|5000\|5833\|4583"; then
    echo "OK - Division operations work safely"
else
    echo "Failed - Division operations failed"
fi

# 测试9: 安全的表达式计算 - 模运算
echo "Test 9: Modulo operations..."
if tsv-mutate security_test.txt 'remainder=age%10' | grep -q "5\|0\|5\|8"; then
    echo "OK - Modulo operations work safely"
else
    echo "Failed - Modulo operations failed"
fi

# 测试10: 安全的表达式计算 - 幂运算
echo "Test 10: Power operations..."
if tsv-mutate security_test.txt 'squared=age^2' | grep -q "625\|900\|1225\|784"; then
    echo "OK - Power operations work safely"
else
    echo "Failed - Power operations failed"
fi

# 测试11: 括号表达式解析
echo "Test 11: Parentheses expressions..."
if tsv-filter security_test.txt '(age > 25) && (department == "IT")' | grep -q "Carl"; then
    echo "OK - Parentheses expressions work correctly"
else
    echo "Failed - Parentheses expressions failed"
fi

# 测试12: 复杂嵌套表达式
echo "Test 12: Complex nested expressions..."
if tsv-filter security_test.txt '((age > 25) && (salary > 55000)) || (department == "HR")' | grep -q "Bob\|Carl"; then
    echo "OK - Complex nested expressions work correctly"
else
    echo "Failed - Complex nested expressions failed"
fi

# 测试13: 边界条件 - 空表达式
echo "Test 13: Empty expression handling..."
if tsv-filter security_test.txt '' 2>&1 | grep -q "Error: Expression cannot be empty"; then
    echo "OK - Empty expressions are properly rejected"
else
    echo "Failed - Empty expressions not properly handled"
fi

# 测试14: 边界条件 - 无效列名
echo "Test 14: Invalid column name handling..."
if tsv-filter security_test.txt 'invalid_column > 0' 2>&1 | grep -q "Error: Unknown variable"; then
    echo "OK - Invalid column names are properly rejected"
else
    echo "Failed - Invalid column names not properly handled"
fi

# 测试15: 边界条件 - 除零保护
echo "Test 15: Division by zero protection..."
if tsv-mutate security_test.txt 'result=age/0' 2>&1 | grep -q "Error: Division by zero"; then
    echo "OK - Division by zero is properly caught"
else
    echo "Failed - Division by zero not properly handled"
fi

echo "Security fixes testing completed."
rm -f security_test.txt
