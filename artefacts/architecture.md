# Arquitetura

## Modelo de Arquitetura

O modelo de arquitetura adotado para este projeto foi o Model-View-ViewModel, ou simplesmente MVVM, que tem como objetivo simplificar e realizar a distribuição de responsabilidades.


![Preview](/images/architecture/mvvm.png?raw=true "")
<br>***Fonte: https://en.wikipedia.org/wiki/Model–view–viewmodel***

**Model**<br>
A camada model no MVVM refere-se a camada de dados, representa o conteúdo e pode possuir regras de negócio.

**View**<br>
É a camada que possui toda estrutura de UI e a mais próxima do usuário.

**ViewModel**<br>
É a camada intermediária entre a view e model , sendo responsável pela parte lógica da camada view e que possui acesso as informações na camada model.

**MVVM em Aplicações iOS**<br>
Ao trabalharmos com MVVM no desenvolvimento de aplicações para iOS seguimos as mesmas responsabilidades das camadas apresentadas anteriormente: model, view e viewmodel, mas no caso do iOS, o controller e a view na prática terminam sendo uma só. Por esse motivo temos a seguinte estrutura da arquitetura MVVM:

![Preview](/images/architecture/iosMvvm.png?raw=true "")

## Arquitetura da Solução

O esquema abaixo visa demonstrar como funciona a arquitetura da solução desenvolvida.

![Preview](/images/architecture/solutionBeckend.png?raw=true "")
