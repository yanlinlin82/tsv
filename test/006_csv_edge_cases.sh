#!/bin/bash

APP_DIR=$(dirname $(dirname $(realpath $0)))
PATH=$PATH:$APP_DIR

echo "Testing CSV parsing edge cases..."

# Test 1: CSV with newlines in quoted fields (should be handled gracefully)
echo "Test 1: CSV with newlines in quoted fields"
cat > test_csv_newlines.csv << 'EOF'
id,description,value
1,"Field with
newlines",100
2,"Another field",200
EOF

output1=$(tsv-align test_csv_newlines.csv 2>&1)
if echo "$output1" | grep -q "Field with" && echo "$output1" | grep -q "newlines"; then
    echo "✓ Test 1 PASSED: Newlines in quoted fields handled gracefully"
else
    echo "✗ Test 1 FAILED: Newlines in quoted fields not handled correctly"
    echo "Output:"
    echo "$output1"
fi

# Test 2: CSV with special characters in quoted fields
echo "Test 2: Special characters in quoted fields"
cat > test_csv_special.csv << 'EOF'
name,text,number
"O'Connor","Contains 'single' quotes",1
"Smith & Jones","Ampersand & symbols",2
"Price: $100","Dollar signs and colons",3
EOF

output2=$(tsv-align test_csv_special.csv)
if echo "$output2" | grep -q "O'Connor" && echo "$output2" | grep -q "Smith & Jones" && echo "$output2" | grep -q "Price: \$100"; then
    echo "✓ Test 2 PASSED: Special characters in quoted fields handled correctly"
else
    echo "✗ Test 2 FAILED: Special characters not handled correctly"
    echo "Output:"
    echo "$output2"
fi

# Test 3: CSV with very long quoted fields
echo "Test 3: Very long quoted fields"
cat > test_csv_long.csv << 'EOF'
id,long_field,short
1,"This is a very long field that contains many characters and should be handled correctly by the CSV parser without any issues even though it's quite lengthy and might cause problems with simple string operations",x
2,"Another long field with, commas, and ""quotes"" mixed in to test the robustness of our parser implementation",y
EOF

output3=$(tsv-align test_csv_long.csv)
if echo "$output3" | grep -q "This is a very long field" && echo "$output3" | grep -q "Another long field with, commas, and \"quotes\""; then
    echo "✓ Test 3 PASSED: Very long quoted fields handled correctly"
else
    echo "✗ Test 3 FAILED: Very long quoted fields not handled correctly"
    echo "Output:"
    echo "$output3"
fi

# Test 4: CSV with only quoted fields
echo "Test 4: CSV with only quoted fields"
cat > test_csv_all_quoted.csv << 'EOF'
"col1","col2","col3"
"value1","value2","value3"
"test,with,commas","another,test","simple"
EOF

output4=$(tsv-align test_csv_all_quoted.csv)
if echo "$output4" | grep -q "test,with,commas" && echo "$output4" | grep -q "another,test"; then
    echo "✓ Test 4 PASSED: CSV with only quoted fields handled correctly"
else
    echo "✗ Test 4 FAILED: CSV with only quoted fields not handled correctly"
    echo "Output:"
    echo "$output4"
fi

# Test 5: CSV with empty file (just headers)
echo "Test 5: CSV with only headers"
cat > test_csv_headers_only.csv << 'EOF'
name,age,city
EOF

output5=$(tsv-align test_csv_headers_only.csv)
if echo "$output5" | grep -q "name" && echo "$output5" | grep -q "age" && echo "$output5" | grep -q "city"; then
    echo "✓ Test 5 PASSED: CSV with only headers handled correctly"
else
    echo "✗ Test 5 FAILED: CSV with only headers not handled correctly"
    echo "Output:"
    echo "$output5"
fi

# Test 6: CSV with malformed quotes (unclosed quotes)
echo "Test 6: CSV with malformed quotes"
cat > test_csv_malformed.csv << 'EOF'
name,description,value
"Unclosed quote,value2,value3
"Properly quoted",normal,123
EOF

# This should handle malformed quotes gracefully
output6=$(tsv-align test_csv_malformed.csv 2>&1)
if echo "$output6" | grep -q "Properly quoted"; then
    echo "✓ Test 6 PASSED: Malformed quotes handled gracefully"
else
    echo "✗ Test 6 FAILED: Malformed quotes not handled correctly"
    echo "Output:"
    echo "$output6"
fi

# Test 7: CSV with different quote characters (should still work with double quotes)
echo "Test 7: CSV with different quote characters"
cat > test_csv_quotes.csv << 'EOF'
field1,field2,field3
"Standard quotes","Mixed 'quotes' inside","More ""nested"" quotes"
EOF

output7=$(tsv-align test_csv_quotes.csv)
if echo "$output7" | grep -q "Mixed 'quotes' inside" && echo "$output7" | grep -q "More \"nested\" quotes"; then
    echo "✓ Test 7 PASSED: Different quote characters handled correctly"
else
    echo "✗ Test 7 FAILED: Different quote characters not handled correctly"
    echo "Output:"
    echo "$output7"
fi

# Test 8: Performance test with many fields
echo "Test 8: Performance test with many fields"
cat > test_csv_many_fields.csv << 'EOF'
f1,f2,f3,f4,f5,f6,f7,f8,f9,f10
"v1","v2","v3","v4","v5","v6","v7","v8","v9","v10"
"test1,with,commas","test2","test3","test4","test5","test6","test7","test8","test9","test10"
EOF

output8=$(tsv-align test_csv_many_fields.csv)
if echo "$output8" | grep -q "test1,with,commas" && echo "$output8" | grep -q "test10"; then
    echo "✓ Test 8 PASSED: Many fields handled correctly"
else
    echo "✗ Test 8 FAILED: Many fields not handled correctly"
    echo "Output:"
    echo "$output8"
fi

# Cleanup test files
rm -f test_csv_*.csv

echo ""
echo "CSV edge case tests completed!"
