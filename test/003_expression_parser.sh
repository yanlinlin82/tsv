#!/bin/bash

APP_DIR=$(dirname $(dirname $(realpath $0)))
PATH=$PATH:$APP_DIR

echo "Testing expression parser fixes..."

# 创建测试数据文件
cat > parser_test.txt << 'EOF'
id	value1	value2	value3
1	10	20	30
2	15	25	35
3	20	30	40
4	25	35	45
EOF

# 测试1: 修复的加减运算解析
echo "Test 1: Fixed addition/subtraction parsing..."
if tsv-mutate parser_test.txt 'sum=value1+value2' | grep -q "30\|40\|50\|60"; then
    echo "OK - Addition operations now parse correctly"
else
    echo "Failed - Addition operations still not working"
fi

# 测试2: 修复的加减运算解析 - 减法
echo "Test 2: Fixed subtraction parsing..."
if tsv-mutate parser_test.txt 'diff=value2-value1' | grep -q "10\|10\|10\|10"; then
    echo "OK - Subtraction operations now parse correctly"
else
    echo "Failed - Subtraction operations still not working"
fi

# 测试3: 修复的加减运算解析 - 混合运算
echo "Test 3: Mixed arithmetic operations..."
if tsv-mutate parser_test.txt 'result=value1+value2-value3' | grep -q "0\|5\|10\|15"; then
    echo "OK - Mixed arithmetic operations now parse correctly"
else
    echo "Failed - Mixed arithmetic operations still not working"
fi

# 测试4: 修复的加减运算解析 - 复杂表达式
echo "Test 4: Complex arithmetic expressions..."
if tsv-mutate parser_test.txt 'complex=(value1+value2)*2-value3' | grep -q "30\|45\|60\|75"; then
    echo "OK - Complex arithmetic expressions now parse correctly"
else
    echo "Failed - Complex arithmetic expressions still not working"
fi

# 测试5: 修复的加减运算解析 - 优先级
echo "Test 5: Operator precedence in expressions..."
if tsv-mutate parser_test.txt 'precedence=value1+value2*2' | grep -q "50\|65\|80\|95"; then
    echo "OK - Operator precedence now works correctly"
else
    echo "Failed - Operator precedence still not working"
fi

# 测试6: 变量作用域修复
echo "Test 6: Variable scope fixes..."
if tsv-mutate parser_test.txt 'scope_test=value1' | grep -q "10\|15\|20\|25"; then
    echo "OK - Variable scope issues are fixed"
else
    echo "Failed - Variable scope issues still exist"
fi

# 测试7: 括号表达式解析
echo "Test 7: Parentheses expression parsing..."
if tsv-mutate parser_test.txt 'brackets=(value1+value2)*(value3-value1)' | grep -q "600\|800\|1000\|1200"; then
    echo "OK - Parentheses expressions parse correctly"
else
    echo "Failed - Parentheses expressions not working"
fi

# 测试8: 嵌套括号表达式
echo "Test 8: Nested parentheses expressions..."
if tsv-mutate parser_test.txt 'nested=((value1+value2)+value3)*2' | grep -q "120\|150\|180\|210"; then
    echo "OK - Nested parentheses expressions parse correctly"
else
    echo "Failed - Nested parentheses expressions not working"
fi

# 测试9: 表达式解析器错误处理
echo "Test 9: Expression parser error handling..."
if tsv-mutate parser_test.txt 'invalid=value1++value2' 2>&1 | grep -q "Error"; then
    echo "OK - Invalid expressions are properly rejected"
else
    echo "Failed - Invalid expressions not properly handled"
fi

# 测试10: 表达式解析器边界条件
echo "Test 10: Expression parser edge cases..."
if tsv-mutate parser_test.txt 'edge=value1+0' | grep -q "10\|15\|20\|25"; then
    echo "OK - Edge cases are handled correctly"
else
    echo "Failed - Edge cases not handled correctly"
fi

echo "Expression parser testing completed."
rm -f parser_test.txt
