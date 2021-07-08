# csv2table
Convert CSV file into SQL dump  query file


Este programa em Perl gera um SQL Dump com base em um arquivo CSV onde na primeira linha tenha os nomes dos campos

Este código está sob licença GPLv3 e contribuições são bem vindas 


No linux baixe o arquivo csv2perl.pl  e de permissão de execução  com o comando 

chmod +x csv2table.pl 

Para uso em todo o sistema você pode executar também: 

sudo mv ./csv2perl.pl   /usr/bin/csv2table


Para usar execute 

csv2table  meuarquivo.csv  nome_nova_tabela

será criado um arquivo  nome_nova_tabela.sql que você pode importar com o cliente do mysql 
