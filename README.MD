INCEPTION




VM Creation:
    -Install any virtual machine assistant(Virtual box in our case)
    -Create VM:
        -VM Name: Inception42-Debian-Trixie
        -Choose VM directory
        -User Name: sylabbe (in our case login42, our volumes are supposed to be place in /home/login/data)
        -Password: sylabbe16
        -Hostname: Inception42-Debian-Trixie(default)
        -Domain name: myguest.virtualbox.org(default)(maybe change this)
        -Base memory: 4096
        -CPUs: 4
        -Disk size: 20 Gb
VM Setup:
    -First add your user to sudo group
        -su -
        -usermod -aG sudo sylabbe
        -exit
    -Update
        -sudo apt-get update
    -Install essentials
        -sudo apt-get install -y build-essential
    -Get project on github
        -1st way: 
            -wget https://github.com/GribGremo/Inception/archive/refs/heads/main.zip
            -unzip main.zip
        -2nd way: 
            -curl -L https://github.com/GribGremo/Inception/archive/refs/heads/master.zip -o Inception.zip
            -unzip main.zip
        3rd way:
            -Need to create ssh and add it to github
                -ssh-keygen -t rsa -b 4096 -C "votre_email@example.com"
                -git clone git@github.com:GribGremo/Inception.git
Setup project:
    -make