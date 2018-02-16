docker build . --tag packer-qemu:local
::docker run --rm -v "%~dp0:/packer:rw" -v "C:/Users/nj1214/Downloads/_ISO Images:/images" --entrypoint "" packer-qemu:local /bin/sh -c "cd /; ls -l; /bin/packer build -var 'pwd=/packer' /packer/ubuntu.json; /bin/sh"
::docker run --rm -it -v "%~dp0:/packer:rw" -v "C:/Users/nj1214/Downloads/_ISO Images:/images" --entrypoint "" packer-qemu:local /bin/sh -c "cd /; ls -l; /bin/packer build -var 'pwd=/packer' /packer/ubuntu.json; /bin/sh"
docker run --rm -it -v "%~dp0:/packer:rw" -v "C:/Users/nj1214/Downloads/_ISO Images:/images" packer-qemu:local build -var 'pwd=/packer' /packer/ubuntu.json
@pause & goto :eof