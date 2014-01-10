all: clean
	sudo wget https://github.com/bh-consulting/snack/archive/master.zip
	sudo unzip master.zip
	sudo mv snack-master interface
	sudo cp -a paquet paquet_deb
	sudo cp db/*.sql paquet_deb/tmp/snack/
	sudo cp -R interface paquet_deb/home/snack/interface
	sudo find paquet_deb -name .svn -exec rm -r {} +
	sudo chmod 0440 paquet_deb/etc/sudoers.d/snack
	sudo cp paquet_deb/home/snack/interface/app/Config/parameters.php.default paquet_deb/home/snack/interface/app/Config/parameters.php
	sudo cp paquet_deb/home/snack/interface/app/Config/database.php.default paquet_deb/home/snack/interface/app/Config/database.php
	sudo chown www-data:www-data paquet_deb/home/snack/interface/app/Config/parameters.php
	sudo chown root:root paquet_deb/etc/sudoers.d/snack
	sudo chmod 777 -R paquet_deb/home/snack/interface/app/tmp
	sudo dpkg-deb --build paquet_deb snack.deb

install:
	sudo dpkg -i snack.deb || (sudo apt-get update && sudo apt-get -y --force-yes -f install)

clean:
	sudo rm -fr paquet_deb snack.deb

uninstall: clean
	sudo apt-get autoremove --purge snack
