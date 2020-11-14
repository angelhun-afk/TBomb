#!/bin/bash

detect_distro() {
    if [ -z "$distro" ]; then
        distro=$(ls /etc | awk 'match($0, "(.+?)[-_](?:release|version)", groups) {if(groups[1] != "os") {print groups[1]}}')
    fi

    if [ -z "$distro" ]; then
        if [[ "$OSTYPE" == linux-android* ]]; then
            distro="termux"
        elif [ -f "/etc/os-release" ]; then
            distro="$(source /etc/os-release && echo $ID)"
        elif [ "$OSTYPE" == "darwin" ]; then
            distro="darwin"
        else 
            distro="invalid"
        fi
    fi
}

pause() {
    read -n1 -r -p "Press any key to continue..." key
}
banner() {
    clear
    echo -e "\e[1;36m"
    if ! [ -x "$(command -v figlet)" ]; then
        echo 'Introducing TBomb'
    else
        figlet TBomb
    fi
    if ! [ -x "$(command -v toilet)" ]; then
        echo -e "\e[4;36m This Bomber Was Created By \e[1;36mSpeedX \e[0m"
    else
        echo -e "\e[1;36mCreated By \e[1;34m"
        toilet -f mono12 -F border SpeedX
    fi
    echo -e "\e[1;36m For Any Queries Mail Me!!!\e[0m"
    echo -e "\e[1;36m           Mail: ggspeedx29@gmail.com \e[0m"
    echo -e "\e[4;36m   YouTube: https://www.youtube.com/c/GyanaTech \e[0m"
    echo " "

}

init_environ(){
    declare -A backends; backends=(
 
        ["termux"]="apt -y install"
        
    )

    INSTALL="${backends[$distro]}"

    if [ "$distro" == "termux" ]; then
        PYTHON="python"
        SUDO=""
    else
        PYTHON="python2"
        SUDO="sudo"
    fi
    PIP="$PYTHON -m pip"
}

install_deps(){
    
    packages=(openssl git $PYTHON $PYTHON-pip figlet toilet)
    if [ -n "$INSTALL" ];then
        for package in ${packages[@]}; do
            $SUDO $INSTALL $package
        done
        $PIP install -r requirements.txt
    else
        echo "We could not install dependencies."
        echo "Please make sure you have git, python2, pip2 and requirements installed."
        echo "Then you can execute bomber.py ."
        exit
    fi
}

banner
pause
detect_distro
init_environ
if [ -f .update ];then
    echo "All Requirements Found...."
else
    echo 'Installing Requirements....'
    echo .
    echo .
    install_deps
    echo This Script Was Made By SpeedX > .update
    echo 'Requirements Installed....'
    pause
fi
while :
do
    banner
    echo -e "\e[4;36m Please Read Instruction Carefully !!! \e[0m"
    echo " "
    echo "Press 1 To  Start SMS  Bomber "
    echo "Press 2 To  Start CALL Bomber "
    echo "Press 3 To  Start MAIL Bomber "
    echo "Press 4 To  Update (Works On Linux And Linux Emulators) "
    echo "Press 5 To  Exit "
    read ch
    clear
    if [ $ch -eq 1 ];then
        $PYTHON bomber.py --sms
        exit
    elif [ $ch -eq 2 ];then
        $PYTHON bomber.py --call
        exit
    elif [ $ch -eq 3 ];then
        $PYTHON bomber.py --mail
        exit
    elif [ $ch -eq 4 ];then
        echo -e "\e[1;36m Downloading Latest Files..."
        rm -f .update
        $PYTHON bomber.py --update
        echo -e "\e[1;36m RUN TBomb Again..."
        pause
        exit
    elif [ $ch -eq 5 ];then
        banner
        exit
    else
        echo -e "\e[4;36m Invalid Input !!! \e[0m"
        pause
    fi
done
