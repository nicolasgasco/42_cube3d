#!/bin/sh

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

MAP_PATH="./tests/maps/color_codes/"
SCRIPT_PATH="./tests/validation_scripts/"
VALGRIND="valgrind --leak-check=full --show-leak-kinds=all"
TEST_OUTPUT="test_output"
VALGRIND_OUTPUT="valgrind_output"
TEST_FILE="test_map.cub"
DEBUG_FILE="debug_output"

VALID_TYPE_IDS="NO path_to_the_north_texture
                SO path_to_the_south_texture
                  
                WE path_to_the_west_texture
                \t\t\t
                EA path_to_the_east_texture
                F 0,0,0
                  
                C 0,10,0
                  "

executeErrorTest() {
    echo "$2" > $SCRIPT_PATH$TEST_FILE
    ./cub3d "$SCRIPT_PATH$TEST_FILE" > /dev/null 2> "$SCRIPT_PATH$TEST_OUTPUT"

    # Output check
    if [ "$(cat $SCRIPT_PATH$DEBUG_FILE)" = "$1" ]
    then
        echo "    ${GREEN}- Valid map (${NC}$(cat $SCRIPT_PATH$TEST_FILE)${GREEN}): ok ✅${NC}"
        echo "        Message:"
        echo "            $1\n"
    else
        echo "    ${RED}- Valid map ($(cat $SCRIPT_PATH$TEST_FILE)): not ok ❌${NC}"
        echo "========================================================================================="
        echo "    Expected:"
        echo "        |$1|\n"
        echo "    Got:"
        echo "        |$(cat $SCRIPT_PATH$DEBUG_FILE)|"
        echo "\n    Error:"
        echo "        |$(cat $SCRIPT_PATH$TEST_OUTPUT)|"
        echo "========================================================================================="
        echo "\n"
        exit 1
    fi

    ERRS_FOUND=$(cat ${SCRIPT_PATH}${TEST_OUTPUT} | grep 'AddressSanitizer' | wc -l)
    # Sanitizer checker
    if [ $ERRS_FOUND -eq 0 ]
    then
        echo "        ${GREEN}No Sanitizer errors detected 👍${NC}"
    else
        echo "        ${RED}Sanitizer errors detected ⛔${NC}"
        echo "\n$(less $SCRIPT_PATH$TEST_OUTPUT)"
        exit 1
    fi

    # Leaks check
    $VALGRIND ./cub3d "$SCRIPT_PATH$TEST_FILE" > /dev/null 2> "$SCRIPT_PATH$VALGRIND_OUTPUT"
    VALGRIND_ERRORS=$(cat $SCRIPT_PATH$VALGRIND_OUTPUT | grep "in use at exit: 0 bytes in 0 blocks" | wc -l)
    if [ $VALGRIND_ERRORS -eq  1 ]
    then
        echo "        ${GREEN}No memory leaks detected 👍${NC}"
    else
        echo "        ${RED}Memory leaks detected ⛔${NC}"
        echo "\n$(less $SCRIPT_PATH$VALGRIND_OUTPUT)"
        exit 1
    fi
    
    # Errors check
    VALGRIND_ERRORS=$(cat $SCRIPT_PATH$VALGRIND_OUTPUT | grep "ERROR SUMMARY: 0 errors from 0 contexts" | wc -l)
    if [ $VALGRIND_ERRORS -eq  1 ]
    then
        echo "        ${GREEN}No Valgrind errors found 👍${NC}"
    else
        echo "        ${RED}Valgrind errors found ⛔${NC}"
        echo "\n$(less $SCRIPT_PATH$VALGRIND_OUTPUT)"
        exit 1
    fi
    echo "=========================================================================================================="
}

echo "\n${YELLOW}MAP HAPPY PATH PATH:${NC}\n"

MAP_CONTENT="${VALID_TYPE_IDS}
        1111111111111111111111111
        1000000000000000000000001
        1100000000000000000000001
        1000000000000000000000001
111111111000000000000000000000001
100000000000000000000000000001111
10000000000000E00000000000001
10000000000000000000000000001
10000000000000000000000000001
10000000000000000000000000001
10000000000000000001010000001
11000001110101011111011110101
11110111 1110111 101111010001
11111111 1111111 111111111111"

DEBUG_MSG="Scene file validated successfully"
executeErrorTest "$DEBUG_MSG" "$MAP_CONTENT"

MAP_CONTENT="${VALID_TYPE_IDS}

        111111111 111111111111111
        100000001 100000000000001
        100000001 100000000000001
        100000001 100000000000001
111111111000000001000000000000001
10000000000000N000000000000001111
10000000000000000000111111111
10000000000000000001
10000000000000000000111111111
10000000000000000000000000001
10000000000000000001010000001
11000001110101011111011110101
11110111 1110111 111111110001
11111111 1111111 111111111111"

DEBUG_MSG="Scene file validated successfully"
executeErrorTest "$DEBUG_MSG" "$MAP_CONTENT"

MAP_CONTENT="${VALID_TYPE_IDS}

        1111111111111111111111111
        1000000000000000000000001
        1100000000000000000000001
        1000000000000000000000001
111111111000000000000000000000001
100000000000000000000000000001111
10000000000000E111111100000001
1000000000000001     100000001
1000000000000001 111 100000001
1000000000000001 1011100000001
1000000000000001 1000000000001
1100000111010101 1111011110101
11110111 1110111 101111010001
11111111 1111111 111111111111"

DEBUG_MSG="Scene file validated successfully"
executeErrorTest "$DEBUG_MSG" "$MAP_CONTENT"


MAP_CONTENT="${VALID_TYPE_IDS}
        1111111111111111111111111
        1000000000000000000000001
        1000000000000001111111111
        1000000000000001
111111110000000000000001
10000000000000000000000011111
11111111111111110000000000001
10000000000000010000000000001
10000111111111110000000000001
10000000000000000000000000001
10000000000000011111100000001
1001111111000001    100000011
10000011 1000001    1000000E1
11111111 1111111    111111111"
DEBUG_MSG="Scene file validated successfully"
executeErrorTest "$DEBUG_MSG" "$MAP_CONTENT"


MAP_CONTENT="${VALID_TYPE_IDS}
111
1N1
111"
DEBUG_MSG="Scene file validated successfully"
executeErrorTest "$DEBUG_MSG" "$MAP_CONTENT"


MAP_CONTENT="${VALID_TYPE_IDS}
1111111111111111
10000000000000N1
1111111111111111"
DEBUG_MSG="Scene file validated successfully"
executeErrorTest "$DEBUG_MSG" "$MAP_CONTENT"

MAP_CONTENT="${VALID_TYPE_IDS}
            111             
            1N1      
            111    "
DEBUG_MSG="Scene file validated successfully"
executeErrorTest "$DEBUG_MSG" "$MAP_CONTENT"

MAP_CONTENT="${VALID_TYPE_IDS}
     111111      111111
    10000001    10000001
    100000001  1000000001
    100000000110000000001111111
    1110000000000000N00000001111
       1000000000000000000000001
       10000000011111000000000001
    1111111000001   10000000000001
          10000001110000000000001
          1000000000000000000001
          111111111111111111111
               11111111111111"
DEBUG_MSG="Scene file validated successfully"
executeErrorTest "$DEBUG_MSG" "$MAP_CONTENT"

MAP_CONTENT="${VALID_TYPE_IDS}
    1111111111111111111111111111111111
    1111111111111111111111111111111111
    111111111111111111111111111
          1111111111111111111111111111111111
          11111111111111111111111111111111111111111
    111111111111111111111111111111111111111
    1111111111111111110N111111111111111111111
    11111111111111111111111111111111
          111111111111111111111111
              111111111111111111111
                11111111111111111111
                1111111111111
                111111111111
                11111111111
                1111111111
                1111111
                11111
                1111
                111"
DEBUG_MSG="Scene file validated successfully"
executeErrorTest "$DEBUG_MSG" "$MAP_CONTENT"

MAP_CONTENT="
${VALID_TYPE_IDS}
        1111111111111111111111111
        1000000000000000000000001
        1100000000000000000000001
        1000000000000000000000001
111111111000000000000000000000001
100000000000000000000000000001111
10000000000000000000000000001
10000000000000000000000000001
10000000000000000000000000001
10000000000000000000000000001
10000000000000000001010000001
11000001110101011111011110101
11110111 1110111 1011110100W1
11111111 1111111 111111111111"
DEBUG_MSG="Scene file validated successfully"
executeErrorTest "$DEBUG_MSG" "$MAP_CONTENT"

MAP_CONTENT="
${VALID_TYPE_IDS}
       111111111111111
    11100000000000000011111
    100000111100000000001
    100001    1111111111111
1111111111111111111111111111
111111111100000011111111N001
        111111111   1111111
       11111
       1111"
DEBUG_MSG="Scene file validated successfully"
executeErrorTest "$DEBUG_MSG" "$MAP_CONTENT"

MAP_CONTENT="
${VALID_TYPE_IDS}
       111111111111111
    11100000000000000011111
    100000111100000000001
    100001    1111111111111
1111111111111111111111111111
111111111100000011111111N001
        111111111   1111111
       11111
       1111
       
       
       
       
       
       
       
       
       "
DEBUG_MSG="Scene file validated successfully"
executeErrorTest "$DEBUG_MSG" "$MAP_CONTENT"

MAP_CONTENT="
${VALID_TYPE_IDS}
        1111111111111111111111111
        1000000000000000000000001
        1100000000000000000000001
        1000000000000000000000001
111111111000000000000000000000001
100000000000000000000000000001111
10000000000000000000000000001
10000000000000000000000000001
10000000000000000000000000001
10000000000000000000000000001
10000000000000000001010000001
11000001110101011111011110101
11110111 1110111 1011110100W1
11111111 1111111 111111111111
"
DEBUG_MSG="Scene file validated successfully"
executeErrorTest "$DEBUG_MSG" "$MAP_CONTENT"

MAP_CONTENT="
${VALID_TYPE_IDS}
        1111111111111111111111111
        1000000000000000000000001
        1100000000000000000000001
        1000000000000000000000001
111111111000000000000000000000001
100000000000000000000000000001111
10000000000000000000000000001
10000000000000000000000000001
10000000000000000000000000001
10000000000000000000000000001
10000000000000000001010000001
11000001110101011111011110101
11110111 1110111 1011110100W1
11111111 1111111 111111111111

"
DEBUG_MSG="Scene file validated successfully"
executeErrorTest "$DEBUG_MSG" "$MAP_CONTENT"

MAP_CONTENT="
${VALID_TYPE_IDS}
        1111111111111111111111111
        1000000000000000000000001
        1100000000000000000000001
        1000000000000000000000001
111111111000000000000000000000001
100000000000000000000000000001111
10000000000000000000000000001
10000000000000000000000000001
10000000000000000000000000001
10000000000000000000000000001
10000000000000000001010000001
11000001110101011111011110101
11110111 1110111 1011110100W1
11111111 1111111 111111111111


"
DEBUG_MSG="Scene file validated successfully"
executeErrorTest "$DEBUG_MSG" "$MAP_CONTENT"

MAP_CONTENT="
${VALID_TYPE_IDS}
        1111111111111111111111111
        1000000000000000000000001
        1100000000000000000000001
        1000000000000000000000001
111111111000000000000000000000001
100000000000000000000000000001111
10000000000000000000000000001
10000000000000000000000000001
10000000000000000000000000001
10000000000000000000000000001
10000000000000000001010000001
11000001110101011111011110101
11110111 1110111 1011110100W1
11111111 1111111 111111111111                             


"
DEBUG_MSG="Scene file validated successfully"
executeErrorTest "$DEBUG_MSG" "$MAP_CONTENT"

MAP_CONTENT="
${VALID_TYPE_IDS}
        1111111111111111111111111
        1000000000000000000000001
        1100000000000000000000001
        1000000000000000000000001
111111111000000000000000000000001
100000000000000000000000000001111
10000000000000000000000000001
10000000000000000000000000001
10000000000000000000000000001
10000000000000000000000000001
10000000000000000001010000001
11000001110101011111011110101
11110111 1110111 1011110100W1
11111111 1111111 111111111111
               "
DEBUG_MSG="Scene file validated successfully"
executeErrorTest "$DEBUG_MSG" "$MAP_CONTENT"