################################################## FONT FORMATTING #####################################################

#=== BOLD ===

function fmtBold() {
    local CURRENT_BOLD="${STATE_MACHINE_BOLD[-1]}";
    local CODE=PRE_"${CURRENT_BOLD}";

    echo -ne "${!CODE}";
}

function fmtBold.open() {                                   # Enables Bold formatting
    stateMachine.push BOLD BOLD;
    fmtBold;
}

function fmtBold.close() {                                  # Disables Bold formatting
     stateMachine.pop BOLD;
     echo -ne "\e[21m";
}

function fmtBold.print() {
    fmtBold.open;
    echo -ne "${@}";
    fmtBold.close;
}

#=== ITALIC ===

function fmtItalic() {
    local CURRENT_ITALIC="${STATE_MACHINE_ITALIC[-1]}";
    local CODE=PRE_"${CURRENT_ITALIC}";

    echo -ne "${!CODE}";
}

function fmtItalic.open() {                                 # Enables Italic formatting
    stateMachine.push ITALIC ITALIC;
    fmtItalic;
}

function fmtItalic.close() {                                # Disables Italic formatting
    stateMachine.pop ITALIC;
    echo -ne "\e[23m";
}

fmtItalic.print() {
    fmtItalic.open;
    echo -ne "${@}";
    fmtItalic.close;
}

#=== UNDERLINE ===

function fmtUnderline() {
    local CURRENT_UNDERLINE="${STATE_MACHINE_UNDERLINE[-1]}";
    local CODE=PRE_"${CURRENT_UNDERLINE}";

    echo -ne "${!CODE}";
}
function fmtUnderline.open() {                              # Enables Underlined formatting
    stateMachine.push UNDERLINE UNDERLINE;
    fmtUnderline;
}

function fmtUnderline.close() {                             # Disables Underlined formatting
    stateMachine.pop UNDERLINE;
    echo -ne "\e[24m";
}

fmtUnderline.print() {
    fmtUnderline.open;
    echo -ne "${@}";
    fmtUnderline.close;
}

######################################################## COLORS ########################################################

function fmtColor() {
    local CURRENT_COLOR="${STATE_MACHINE_COLOR[-1]}";
    local CODE=PRE_COLOR_"${CURRENT_COLOR}";

    echo -ne "${!CODE}";
}

function fmtColor.open() {
    stateMachine.push COLOR "${1^^}";
    fmtColor;

}

function fmtColor.close() {
    stateMachine.pop COLOR;
    if isColor; then
        fmtColor;
    else
        echo -ne "\e[39m";
    fi
}

function fmtColor.print() {
    fmtColor.open "${1}";
    echo -ne "${@:2}";
    fmtColor.close;
}

#################################################### BACKGROUNDS #######################################################

function fmtBackground() {
    local CURRENT_BACKGROUND="${STATE_MACHINE_BACKGROUND[-1]}";
    local CODE=PRE_BACKGROUND_"${CURRENT_BACKGROUND}";

    echo -ne "${!CODE}";
}

function fmtBackground.open() {
    stateMachine.push BACKGROUND "${1^^}";

    fmtBackground;

}

function fmtBackground.close() {
    stateMachine.pop BACKGROUND;

    if isBackground; then
        fmtBackground;
    else
        echo -ne "\e[49m";
    fi
}

function fmtBackground.print() {
    fmtBackground.open "${1}";
    echo -ne "${@:2}";
    fmtBackground.close;
}

################################################### TEXT ALIGNMENT #####################################################

function fmtIndent() {
    local CURRENT_INDENT="${STATE_MACHINE_INDENT[-1]}";
    local CODE=PRE_INDENT_"${CURRENT_INDENT}";

    echo -ne "${!CODE}";
}


function fmtIndent.open() {                                    # Create the next level of indention
    local VAR=$( expr ${#STATE_MACHINE_INDENT[@]} + 1 );

    stateMachine.push INDENT ${VAR};
    fmtIndent;
}

function fmtIndent.close() {                                   # Restores previous level of indention
    stateMachine.pop INDENT;

    if isIndent; then
        fmtIndent;
    else
        echo -ne "";
    fi
}

function fmtIndent.print() {
    fmtIndent.open;
    echo -e "${@}";
    fmtIndent.close;
}


function fmtAlign.center() {
    local columns="$(tput cols)";
    local string="${*}";

    printf "%*s\n" $(((${columns} + ${#string}) /2)) "${string}";
}

function fmtAlign.right() {
    local columns="$(tput cols)";
    local string=$(echo ${1});

    printf "%*s\n" "${columns}" "${string}";
}

################################################## PRINTING ############################################################

function fmtBlankLine() {                                     # Prints an empty line
    echo -ne "\n";
}

function fmtUppercase() {                                 # Prints a string transformed into uppercase
    echo -ne "${*^^}";                                          # formatted according to attributes values
}

function fmtLowercase() {                                 # Prints a string transformed into lowercase
    echo -ne "${*,,}";                                          # formatted according to attributes values
}

function fmtSectionLine() {                                     # Prints a section line using the given argument
    local PRE=$'\e(0';
    local SUFF=$'\e(B';
    local CHAR="${1}";
    local COLS=${COLUMNS:-$(tput cols)};

    echo -e "";
    while ((${#CHAR} < COLS)); do CHAR+="${CHAR}"; done;
    printf "%s%s%s\n" "${PRE}" "${CHAR:0:COLS}" "${SUFF}";
    echo -e "";
}

################################################## Predefined styles ###################################################

# Information section =====
function fmtInfoSection() {
    local HEADER="${1}";
    local CONTENT="${@:2}";

    fmtInfoSection.header "${HEADER}";
    fmtInfoSection.content "${CONTENT}";
    fmtResetFormatting;
}

function fmtInfoSection.header() {
    local CONTENT="${*}";

    fmtSectionLine "q";
    fmtBold.open;
    fmtColor.open "green";
    fmtAlign.center "${CONTENT^^}";
    fmtColor.close && fmtBold.close;
}

function fmtInfoSection.content() {
    local CONTENT="${*}";

    fmtSectionLine "q";
    fmtItalic.open;
    fmtIndent.print "${CONTENT}";
    fmtSectionLine "q";
}

# Error section =====
function fmtErrorSection() {
    local HEADER="${1}";
    local CONTENT="${@:2}";

    fmtErrorSection.header "${HEADER}";
    fmtErrorSection.content "${CONTENT}";
    fmtResetFormatting;
}

function fmtErrorSection.header() {
    local CONTENT="${*}";

    fmtSectionLine "q";
    fmtBold.open;
    fmtColor.open "red";
    fmtAlign.center "${CONTENT^^}";
    fmtColor.close && fmtBold.close;
}

function fmtErrorSection.content() {
    local CONTENT="${*}";

    fmtSectionLine "q";
    fmtItalic.open;
    fmtIndent.print "${CONTENT}";
    fmtSectionLine "q";
}

# Warning section =====
function fmtWarningSection() {
    local HEADER="${1}";
    local CONTENT="${@:2}";

    fmtWarningSection.header "${HEADER}";
    fmtWarningSection.content "${CONTENT}";
    fmtResetFormatting;
}

function fmtWarningSection.header() {
    local CONTENT="${*}";

    fmtSectionLine "q";
    fmtBold.open;
    fmtColor.open "yellow";
    fmtAlign.center "${CONTENT^^}";
    fmtColor.close && fmtBold.close;
}

function fmtWarningSection.content() {
    local CONTENT="${*}";

    fmtSectionLine "q";
    fmtItalic.open;
    fmtIndent.print "${CONTENT}";
    fmtSectionLine "q";
}

fmtList.print() {
    for num in "${@:2}"; do printf "\t %10s %s \n" "${1}" "$num"; done
}

# List ===== #todo

######################################################## LOGOS ########################################################

function fmtPrint.logo() {
    local cols="$(tput cols)";

    if [ "${cols}" -le 202 ];
    then
        fmtPrint.lineSolid;
        fmtAlign.center "|                                                          |";
        fmtAlign.center "|       _____                 __         _  __             |";
        fmtAlign.center "|      / ___/____ ___  ___ _ / /_ __ __ (_)/ /_ __ __      |";
        fmtAlign.center "|     / /__ / __// -_)/ _  // __// // // // __// // /      |";
        fmtAlign.center "|     \___//_/   \__/ \_,_/ \__/ \_,_//_/ \__/ \_, /       |";
        fmtAlign.center "|                                             /___/        |";
        fmtAlign.center "|                                                          |";
        fmtAlign.center "|                  ____ __                   _     __      |";
        fmtAlign.center "|    ___   ___    / __// /_ ___  ____ ___   (_)___/ /___   |";
        fmtAlign.center "|   / _ \ / _ \  _\ \ / __// -_)/ __// _ \ / // _  /(_-<   |";
        fmtAlign.center "|   \___//_//_/ /___/ \__/ \__//_/   \___//_/ \_,_//___/   |";
        fmtAlign.center "|                                                          |";
        fmtPrint.lineSolid;
    else
        fmtAlign.center "                                                                                                                              MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM                             "
        fmtAlign.center "                                                                                                                           MMMMMMMMMMMMMMMMMMMMMMMMM   MMMMMMMMMMMMMMMMMMMMMMMMM                          "
        fmtAlign.center "                                                                                                                        MMMMMMMMMMMMMMMMMMMMMMMMMMM     MMMMMMMMMMMMMMMMMMMMMMMMMMM                       "
        fmtAlign.center "                                                                                                                       MMMMMMMMMMMMMMMMMMMMMMMMMMMM     MMMMMMMMMMMMMMMMMMMMMMMMMMMM                      "
        fmtAlign.center "                                                                                                                      MMMMMMMMMMMMMMMMMMMMMMMMMMMMM     MMMMMMMMMMMMMMMMMMMMMMMMMMMMM                     "
        fmtAlign.center "                                                                                                                     MMMMMMMMMMMMMMM     MMMMMMMMMM     MMMMMMMMMM     MMMMMMMMMMMMMMM                    "
        fmtAlign.center "                                                                                                                    MMMMMMMMMMMMMMMM      MMMMMMMMM     MMMMMMMMM      MMMMMMMMMMMMMMMM                   "
        fmtAlign.center "                                                                                                                   MMMMMMMMMMMMMMMMMM      MMMMMMMM     MMMMMMMM      MMMMMMMMMMMMMMMMMM                  "
        fmtAlign.center "                                                                                                                   MMMMMMMMMMMMMMMMMMM      MMMMMMM     MMMMMMM      MMMMMMMMMMMMMMMMMMM                  "
        fmtAlign.center "                                                                                                                  MMMMMMMMMMMMMMMMMMMMM      MMMMMMM   MMMMMMM      MMMMMMMMMMMMMMMMMMMMM                 "
        fmtAlign.center "                                                                                                                  MMMMMMMMMMMMMMMMMMMMMMM     MMMMMMMMMMMMMMM     MMMMMMMMMMMMMMMMMMMMMMM                 "
        fmtAlign.center "                                                                                                                 MMMMMMMMMMMMMMMMMMMMMMMMM     MMMMMMMMMMMMM     MMMMMMMMMMMMMMMMMMMMMMMMM                "
        fmtAlign.center "                                                                                                                 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM      MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM                "
        fmtAlign.center "                                                                                                                 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM          MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM                "
        fmtAlign.center "                                                                                                                 MMMMMMMMMMMMM              MMMM            MMMM              MMMMMMMMMMMM                "
        fmtAlign.center "                                                                                                                 MMMMMMMMMMMM               MMMM            MMMM               MMMMMMMMMMM                "
        fmtAlign.center "                                                                                                                 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM            MMMMMMMMMMMMMMMMMMMMMMMMMMMMMM                "
        fmtAlign.center "                                                                                                                 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM      MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM                "
        fmtAlign.center "                                                                                                                 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM                "
        fmtAlign.center "MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNMMMMMMMMMMMMMMMMMMMMM"
        fmtAlign.center "MMMMMMM           MMMMMMMMMM                  MMMMMMMMM                MMMMMMMMMMMMMMM  MMMMMMMM                   MMMMM    MMMMMMMMMMMMMM    MMMMM      MMMMM                   MMMMM    MMMMMMMMMMM    M"
        fmtAlign.center "MMMMM               MMMMMMMM    MMMMMMMMM       MMMMMMM                MMMMMMMMMMMMMM    MMNMMMM                   MMMMM    MMMMMMMMMMMMMM    MMMMM      MMMMM                   MMMMMM    MMMMMMMMM    MM"
        fmtAlign.center "MMM     MMMMMMMMM     MMMMMM    MMMMMMMMMMM      MMMMMM    MMMMMMMMMMMMMMMMMMMMMMMMM      MMMMMMMMMMMMM     MMMMMMMMMMMM    MMMMMMMMMMMMMM    MMMMM      MMMMMMMMMMMM     MMMMMMMMMMMMMM    MMMMMMM    MMM"
        fmtAlign.center "MM    MMMMMMMMMMMMM    MMMMM    MMMMMMMMMMMM      MMMMM    MMMMMMMMMMMMMMMMMMMMMMMM        MMMMMMMMMMMM     MMMMMMMMMMMM    MMMMMMMMMMMMMM    MMMMM      MMMMMMMMMMMM     MMMMMMMMMMMMMMM    MMMMM    MMMM"
        fmtAlign.center "M    MMMMMMMMMMMMMMMMMMMMMMM    MMMMMMMMMMMM     MMMMMM    MMMMMMMMMMMMMMMMMMMMMMM    MM    MMMMMMMMMMM     MMMMMMMMMMMM    MMMMMMMMMMMMMM    MMMMM      MMMMMMMMMMMM     MMMMMMMMMMMMMMMM    MMM    MMMMM"
        fmtAlign.center "M    MMMMMMMMMMMMMMMMMMMMMMM    MMMMMMMMMMM     MMMMMMM                MMMMMMMMMM    MMMM    MMMMMMMMMM     MMMMMMMMMMMM    MMMMMMMMMMMMMM    MMMMM      MMMMMMMMMMMM     MMMMMMMMMMMMMMMMM    M    MMMMMM"
        fmtAlign.center "M    MMMMMMMMMMMMMMMMMMMMMMM    MMMMMMMMM      MMMMMMMM                MMMMMMMMM    MMMMMM    MMMMMMMMM     MMMMMMMMMMMM    MMMMMMMMMMMMMM    MMMMM      MMMMMMMMMMMM     MMMMMMMMMMMMMMMMMM       MMMMMMM"
        fmtAlign.center "M    MMMMMMMMMMMMMMMMMMMMMMM                MMMMMMMMMMM    MMMMMMMMMMMMNMMMMMMM    MMMMMMMM    MMMMMMMM     MMMMMMMMMMMM    MMMMMMMMMMMMMM    MMMMM      MMMMMMMMMMMM     MMMMMMMMMMMMMMMMMMM     MMMMMMMM"
        fmtAlign.center "M     NMMMMMMMMMMMMMMMMMMMMM    MMMMM     MMMMMMMMMMMMM    MMMMMMMMMMMMMMMMMMM                  MMMMMMM     MMMMMMMMMMMM    MMMMMMMMMMMMMM    MMMMM      MMMMMMMMMMMM     MMMMMMMMMMMMMMMMMMM     MMMMMMMM"
        fmtAlign.center "MM      MMMMMMMMMMM    MMMMM    MMMMMM     MMMMMMMMMMMM    MMMMMMMMMMMMMMMMMM    MMMMMMMMMMMM    MMMMMM     MMMMMMMMMMMM     MMMMMMMMMMMM     MMMMM      MMMMMMMMMMMM     MMMMMMMMMMMMMMMMMMM     MMMMMMMM"
        fmtAlign.center "MMM       MNMMMMM     MMMMMM    MMMMMMMM     MMMMMMMMMM    MMMMMMMMMMMMMMMMM    MMMMMMMMMMMMMM    MMMMM     MMMMMMMMMMMMM     MMMMMMMMMM     MMMMMM      MMMMMMMMMMMM     MMMMMMMMMMMMMMMMMMM     MMMMMMMM"
        fmtAlign.center "MMMMMM               MMMMMMM    MMMMMMMMM     MMMMMMMMM                MMMM    MMMMMMMMMMMMMMMM    MMMM     MMMMMMMMMMMMMM                  MMMMMMM      MMMMMMMMMMMM     MMMMMMMMMMMMMMMMMMM     MMMMMMMM"
        fmtAlign.center "MMMMMMMM          NMMMMMMMMM    MMMMMMMMMM     MMMMMMMM                MMM    MMMMMMMMMMMMMMMMMM    MMM     MMMMMMMMMMMMMMMMM           MMMMMMMMMMM      MMMMMMMMMMMM     MMMMMMMMMMMMMMMMMMM     MMMMMMMM"
        fmtAlign.center "MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM"
    fi
}
################################################ VARIABLES DECLARATION #################################################

function fmtResetFormatting() {                                 # Resets formatting for the given attributes
    declare -a -g STATE_MACHINE_BOLD=( );
    declare -a -g STATE_MACHINE_ITALIC=( );
    declare -a -g STATE_MACHINE_UNDERLINE=( );
    declare -a -g STATE_MACHINE_COLOR=( );
    declare -a -g STATE_MACHINE_BACKGROUND=( );
    declare -a -g STATE_MACHINE_INDENT=( );

    echo -ne "\e[0m";
#    declare -a -g STATE_MACHINE_LIST=( );
}

function fmtDeclarePrefixes() {
#BOLD,ITALIC,UNDERLINE
    PRE_BOLD="\e[1m";
    PRE_ITALIC="\e[3m";
    PRE_UNDERLINE="\e[4m";
#COLORS:
    PRE_COLOR_REVERSED="\e[7m";
    PRE_COLOR_RED="\e[91m";
    PRE_COLOR_GRAY="\e[90m";
    PRE_COLOR_YELLOW="\e[93m";
    PRE_COLOR_GREEN="\e[32m";
    PRE_COLOR_BLUE="\e[34m";
    PRE_COLOR_PURPLE="\e[35m";
    PRE_COLOR_WHITE="\e[97m"
    PRE_COLOR_BLACK="\e[30m"
#BACKGROUND:
    PRE_BACKGROUND_RED="\e[101m";
    PRE_BACKGROUND_GRAY="\e[100m";
    PRE_BACKGROUND_YELLOW="\e[103m";
    PRE_BACKGROUND_GREEN="\e[42m";
    PRE_BACKGROUND_BLUE="\e[44m";
    PRE_BACKGROUND_PURPLE="\e[45m";
    PRE_BACKGROUND_WHITE="\e[107m";
    PRE_BACKGROUND_DEFAULT="\e[49m";
#INDENTION:
    PRE_INDENT_1="\t";
    PRE_INDENT_2="\t\t";
    PRE_INDENT_3="\t\t\t";
    PRE_INDENT_4="\t\t\t\t";
}

######################################################### TESTS ########################################################

function testIf() {
    ARG_NUMBER="${1}"
    if [[ ${ARG_NUMBER} == 0 ]]; then
        return 1
    else
        return 0
    fi
}

function isBold() {
    testIf "${#STATE_MACHINE_BOLD[@]}";
}

function isItalic() {
    testIf "${#STATE_MACHINE_ITALIC[@]}";
}

function isUnderline() {
    testIf "${#STATE_MACHINE_UNDERLINE[@]}";
}

function isColor() {
    testIf "${#STATE_MACHINE_COLOR[@]}";
}

function isBackground() {
    testIf "${#STATE_MACHINE_BACKGROUND[@]}";
}

function isIndent() {
    testIf "${#STATE_MACHINE_INDENT[@]}";
}

function isList() {
    testIf "${#STATE_MACHINE_LIST[@]}";
}