TODO für RVM
============

1. Der User www-data, unter dem graylog läuft, muss als login-shell die bash bekommen
2. Der User www-data muss der Gruppe rvm angehören
3. Im Deployment-Verzeichnis kann man ein .rvmrc-File hinlegen. Das muss generiert werden und
   geht über 
   rvm --rvmrc use ruby-1.9.3