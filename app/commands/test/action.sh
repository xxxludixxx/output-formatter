
function runAction() {
    #config.sh loaded automatically
    #echo "TEST MODULE"
    #echo ""

    #loading config file dev.sh in order
    #core/config/common/dev.sh
    #app/config/common/dev.sh
    #core/config/env/local/dev.sh
    #app/config/env/local/dev.sh
    #core/config/role/developer/dev.sh
    #app/config/role/developer/dev.sh
    configLoad "dev.sh"
    configLoad "output-formatter-variables.sh"
    #Call function from module app/modules/example.sh
    for i in $*; do
    fmtPrint.content "# $i"
    done;
    fmtPrint.lineA;
    fmtPrint.blank;
#    fmtBold.close && fmtPrint.content "This should not be Bold";
#    fmtUnderline.open && fmtPrint.content "This should be Underlined";
#    fmtUnderline.close && fmtPrint.content "This should not be Underlined";
#    fmtItalic.open && fmtPrint.content "This should be in Italics";
#    fmtItalic.close && fmtPrint.content "This should not be in Italics";
#    fmtBold.open && fmtUnderline.open && fmtItalic.open && fmtPrint.content "This should be Bold, Underlined and in Italics";
#    fmtPrint.blank;
#    fmtPrint.lineA;
#    fmtPrint.blank;
#    fmtBold.close && fmtColorRed.open && fmtPrint.content "This should be written in Red, Underlined and in Italics";
#    fmtColorBlue.open && fmtPrint.content "This should be written in Blue, Underlined and in Italics";
#    fmtColorGreen.open && fmtPrint.content "This should be written in Green, Underlined and in Italics";
#    fmtColorYellow.open && fmtPrint.content "This should be written in Yellow, Underlined and in Italics";
#    fmtColorPurple.open && fmtPrint.content "This should be written in Purple, Underlined and in Italics";
#    fmtColor.close && fmtPrint.content "This should be written in Yellow, Underlined and in Italics";
#    fmtColor.close && fmtPrint.content "This should be written in Green, Underlined and in Italics";
#    fmtColor.close && fmtPrint.content "This should be written in Blue, Underlined and in Italics";
#    fmtColor.close && fmtPrint.content "This should be written in Red, Underlined and in Italics";
#    fmtColor.close && fmtUnderline.close && fmtItalic.close && fmtPrint.content "This should be written in White";
#    fmtPrint.blank;
#    fmtPrint.lineA;
    #Call function 'gitState' from module app/modules/git.sh
    #'gitState' from core/modules/git.sh was overridden
}