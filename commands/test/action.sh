
function runAction() {
    #config.sh loaded automatically
    #loading config file dev.sh in order
    #core/config/common/dev.sh
    #app/config/common/dev.sh
    #core/config/env/local/dev.sh
    #app/config/env/local/dev.sh
    #core/config/role/developer/dev.sh
    #app/config/role/developer/dev.sh
    configLoad "dev.sh";
    configLoad "output-formatter-variables.sh";
    #Call function from module app/modules/example.sh
    fmtBold.open;
    echo -e "Działa";
    #Call function 'gitState' from module app/modules/git.sh
    #'gitState' from core/modules/git.sh was overridden
}