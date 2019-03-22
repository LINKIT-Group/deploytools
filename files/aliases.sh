
function __check_env_project(){
    if [ -z "$PROJECT_PATH" ];then
        echo "PROJECT_PATH not set correctly in docker-compose"
        return 1
    fi
    return 0
}

function __makegit(){
    # wrapper function around python3 -m makegit to pass GIT_URL from make command

    # check if environment vars are set
    if [ -z "$GIT_URL" ];then
        echo "url expected as shell variable (make git url=\${GIT_URL}"
        return 1
    fi
    __check_env_project || return 1
    
    # store current path
    current_path="$PWD"

    # cd into project and execute python3 -m makegit
    cd "${PROJECT_PATH}" && \
        python3 -m makegit --url "${GIT_URL}"
    return_code="$?"

    # return to starting directory and return
    cd "$current_path" 2>/dev/null
    return $return_code
}

function __remotestate(){
    # wrapper function around python3 -m remotestate

    # check if environment vars are set
    __check_env_project || return 1

    # store current path
    current_path="$PWD"

    # cd into project and execute python3 -m remotestate
    cd "${PROJECT_PATH}" && \
        python3 -m remotestate --git "build/buildrepo"
    return_code="$?"

    # return to starting directory and return
    cd "$current_path" 2>/dev/null
    return $return_code
}


function __terraform(){
    # change to terraform directory of the project
    # and run with all original parameters passed
    current_path="$PWD"
    __check_env_project || return 1


    terraform_path="${PROJECT_PATH}/build/buildrepo/terraform"
    if [ ! -d "$terraform_path" ];then
        echo "/terraform path (./build/buildrepo/terraform) missing"
        cd "$current_path" >/dev/null
        return 1
    fi
    
    if [ -z "$1" ];then
        # switch to terraform directory and exit
        cd "$terraform_path"
        return $?
    fi
    
    backend_file="${PROJECT_PATH}/buildrepo/terraform/backend_auto.tf"
    if [ ! -s "$backend_file" ];then
        # backend not yet set, executing remote state first
        echo "updating backend configuration"
        __remotestate || return 1
        [ -s "$backend_file" ] || return 1
    fi

    # execute terraform 
    cd "$terraform_path" && \
        terraform $@
    return_code="$?"

    cd "$current_path" >/dev/null
    return $return_code
}

alias makegit='__makegit'
alias remotestate='__remotestate'
alias terraform='__terraform'
