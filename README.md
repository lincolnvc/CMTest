# CMTest
Teste de Avaliação Técnica para Desenvolvedor SysPDV

Avaliação Técnica 3 para Desenvolvedor
Equipe SysPDV

1 - Busca performática
Buscar registro de forma performática em lista de dados aleatórios de 50 mil registros. O valor a
ser buscado é passado como parâmetro.

2 - Conversão de objeto
Converter um objeto para json. O objeto deve conter propriedades de tipos variados, inclusive
arrays. Na conversão para json as propriedades do objeto devem ter seus nomes alterados para
os nomes previamente especificados na classe. Pelo menos uma propriedade não deve
aparecer no json; esta propriedade também deve estar previamente especificada na classe para
atender este comportamento (se implementado em Delphi, desejável uso de attributes). No
momento da conversão validar se existe alguma propriedade do objeto não preenchida; caso
tenha, mostrar erro e impedir a conversão.

3 - Gerenciador de recurso multi-thread
Implementar recurso que gerencie a escrita e leitura de 3 threads. Todas vão escrever na mesma
lista um contador de 0 a 100, identificando qual thread (1, 2 ou 3) está escrevendo, sem deixar
que a aplicação entre em deadlock. Observação importante: para que a aplicação esteja segura
somente uma thread pode acessar o recurso (para escrita) por vez. Se torna um diferencial para
este desafio que as 3 threads consigam acessar o recurso (para leitura) ao mesmo tempo.
