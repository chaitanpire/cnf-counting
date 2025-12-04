dst=~/tmp/sensitivity

cps=models/sbi models/load_tests utils src outputs unit-tests requirements.txt README.md

all:
	rm -rf $(dst)
	mkdir -p $(dst)
	mkdir -p $(dst)/models
	echo "$(cps)"
	for c in $(cps); do cp -r ./$$c $(dst)/$$c; done;
	cp ./Dockerfile_SBI $(dst)/Doeckerfile;
	tar -cvf $(dst).tar $(dst)

binary:
	pyinstaller ./sensitive.spec

reqtest:
	python -m venv /tmp/myenv

runvmtest:
	multipass launch 24.04 -n vmtest -m 4G --disk 20G
	multipass stop vmtest
	multipass exec -n vmtest -- bash -c "sudo snap install multipass-sshfs"
	multipass exec -n vmtest -- bash -c "sudo apt install make cmake g++ python-is-python3 python3-pip graphviz"
	multipass mount $(pwd) vmtest
	multipass exec -n vmtest -- bash -c "pip freeze > requirements.txt" 
	multipass delete vmtest
	multipass purge

