#!/bin/bash

APP_DIR=$(dirname $(dirname $(realpath $0)))
PATH=$PATH:$APP_DIR

echo "Testing CSV parsing functionality..."

# Test 1: Basic CSV with quoted fields containing commas
echo "Test 1: Quoted fields with commas"
cat > test_csv_test1.csv << 'EOF'
query_name,pubchem_cid
"9S,11S,15S-Trihydroxy-5Z,13E-prostadienoic acid",5280886
EOF

# Check if the field is parsed as one field (not split by commas)
output1=$(tsv-align test_csv_test1.csv)
if echo "$output1" | grep -q "9S,11S,15S-Trihydroxy-5Z,13E-prostadienoic acid"; then
    echo "OK - Quoted fields with commas parsed correctly as single field"
else
    echo "Failed - Quoted fields with commas split incorrectly"
fi

# Test 2: CSV with escaped quotes
echo "Test 2: Escaped quotes (double quotes)"
cat > test_csv_test2.csv << 'EOF'
name,description,value
"Smith, John","Contains ""quoted"" text",123
"Johnson, Mary","Field with, commas, inside",456
EOF

# Check if escaped quotes and commas in quotes are handled correctly
output2=$(tsv-align test_csv_test2.csv)
if echo "$output2" | grep -q "Smith, John" && echo "$output2" | grep -q "Contains \"quoted\" text"; then
    echo "OK - Escaped quotes and commas in quotes handled correctly"
else
    echo "Failed - Escaped quotes or commas not handled correctly"
fi

# Test 3: Mixed quoted and unquoted fields
echo "Test 3: Mixed quoted and unquoted fields"
cat > test_csv_test3.csv << 'EOF'
field1,field2,field3,field4
"Quoted, field",unquoted,"Another, quoted",simple
EOF

# Check if mixed fields are parsed correctly
output3=$(tsv-align test_csv_test3.csv)
if echo "$output3" | grep -q "Quoted, field" && echo "$output3" | grep -q "Another, quoted"; then
    echo "OK - Mixed quoted and unquoted fields handled correctly"
else
    echo "Failed - Mixed fields not handled correctly"
fi

# Test 4: Empty quoted fields
echo "Test 4: Empty quoted fields"
cat > test_csv_test4.csv << 'EOF'
col1,col2,col3
"",,"empty"
EOF

# Check if empty quoted fields are handled correctly
output4=$(tsv-align test_csv_test4.csv)
if echo "$output4" | grep -q "empty"; then
    echo "OK - Empty quoted fields handled correctly"
else
    echo "Failed - Empty quoted fields not handled correctly"
fi

# Test 5: Complex nested quotes and commas
echo "Test 5: Complex nested quotes and commas"
cat > test_csv_test5.csv << 'EOF'
id,complex_field,simple
1,"Field with ""nested"" quotes and, commas",value
2,"Another ""complex"" field, with, multiple, commas",123
EOF

# Check if complex fields are parsed correctly
output5=$(tsv-align test_csv_test5.csv)
if echo "$output5" | grep -q "Field with \"nested\" quotes and, commas" && echo "$output5" | grep -q "Another \"complex\" field, with, multiple, commas"; then
    echo "OK - Complex nested quotes and commas handled correctly"
else
    echo "Failed - Complex fields not handled correctly"
fi

# Test 6: Verify TSV files still work correctly (backward compatibility)
echo "Test 6: Backward compatibility with TSV files"
cat > test_tsv_test6.txt << 'EOF'
name	age	city
Alice	20	New York
Bob	15	Los Angeles
EOF

# Check if TSV files still work
output6=$(tsv-align test_tsv_test6.txt)
if echo "$output6" | grep -q "Alice" && echo "$output6" | grep -q "Bob"; then
    echo "OK - TSV files still work correctly"
else
    echo "Failed - TSV files broken"
fi

# Test 7: CSV with trailing commas
echo "Test 7: CSV with trailing commas"
cat > test_csv_test7.csv << 'EOF'
col1,col2,col3,
"value1","value2","value3",
EOF

# Check if trailing commas are handled correctly
output7=$(tsv-align test_csv_test7.csv)
if echo "$output7" | grep -q "value1" && echo "$output7" | grep -q "value2" && echo "$output7" | grep -q "value3"; then
    echo "OK - Trailing commas handled correctly"
else
    echo "Failed - Trailing commas not handled correctly"
fi

# Test 8: Verify the original problematic case works
echo "Test 8: Original problematic case"
cat > test_original_case.csv << 'EOF'
query_name,pubchem_cid
"9S,11S,15S-Trihydroxy-5Z,13E-prostadienoic acid",5280886
EOF

# This should NOT create extra columns like _1, _2, _3
output8=$(tsv-align test_original_case.csv)
if echo "$output8" | grep -q "_1\|_2\|_3"; then
    echo "Failed - Still creating extra columns from commas in quotes"
else
    echo "OK - No extra columns created from commas in quotes"
fi

# Cleanup test files
rm -f test_csv_test*.csv test_tsv_test*.txt test_simple.csv test_original_case.csv

echo ""
echo "CSV parsing tests completed!"
