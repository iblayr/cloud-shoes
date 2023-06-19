
## A empresa
<hr>
A Cloud Shoes é uma empresa do ramo calçadista, fundada no ano de 2015 e tem passado por um processo de expansão, onde tem elevado seu número
de clientes e vendas consideravelmente.<br>
Nos últimos anos a Cloud Shoes passou por um processo de simplificação de sua
estrutura, fechando sua loja física e passando a atuar somente em formato e-
commerce.
Devido a essa mudança estrutural da empresa, é fundamental a busca por avanços
tecnológicos frequentes, visando melhorar a experiência do cliente final e
consequentemente transformar isso em lucratividade e crescimento para empresa.<br>
A Cloud Shoes comercializa exclusivamente calçados e tem como objetivos futuros
avançar nas vendas de vestuário. Hoje a empresa trabalha em vendas somente no
Brasil e em um curto espaço de tempo não tem movimentos para expandir para fora do
país.

A empresa conta hoje com a seguinte estrutura:

- 500 colaboradores;
- 50 fornecedores (terceirizados);
- Sede da empresa em São Paulo;
- Escritório administrativo em Belo Horizonte;
- Estrutura de TI (datacenter) em São Paulo.

## Estrutura de TI
<hr>

A Cloud Shoes hoje apresenta a seguinte estrutura de TI:
- Datacenter próprio na Sede da empresa em São Paulo;
- Possui mais de 10 aplicações rodando para suportar o negócio da empresa;
- Possui aproximadamente 120 servidores de produção ativos;
- Possui aproximadamente 40 servidores de desenvolvimento e homologação ativos;
- Toda a estrutura de servidores é executada sobre virtualização com VMware rodando
- sobre 10 servidores físicos;
- A empresa utiliza sistemas operacionais Windows Server e Linux (Ubuntu Server e
RedHat);
- O banco de dados é SQL Server 2016 Enterprise;
- A empresa possui 2 Storages com discos SSD;
- A política de renovação de servidores físicos é de 5 em 5 anos.
- A última renovação foi realizada em 2020.

## Estrutura de E-Commerce
<hr>
Hoje o principal workload da Cloud Shoes é seu site de E-Commerce. Essa é a aplicação mais
crítica, onde ocorre todo o processo de venda da Cloud Shoes.
A estrutura do site é composta pelos seguintes serviços:

- 4 servidores Windows Server 2019 - Frontend – Rodando IIS
- 4 Servidores Windows Server 2019 - Backend
- 2 Servidores Windows Server 2016 - SQL Server com Cluster Failover
- 1 servidore Windows Server 2012 – Serviço integração com o ERP
- Storage para o catalogo de imagens do site com capacidade de 2TB – 70% em uso
- Storage utilizado para armazenamento das bases de dados do SQL Server – 60% em uso
- 1 Firewall de borda fazendo balanceamento de carga para os servidores de frontend
- 1 balanceador de carga interno compartilhado para todas aplicações

![architecture](diagram_01.png?raw=true "Architecture")

<br>

![components](diagram_02.png?raw=true "Components")


## Estatísticas do E-Commerce
<hr>

Hoje Cloud Shoes apresenta a seguinte tabela com médias de acessos para os principais
períodos de vendas do comércio no Brasil:

Datas | Acessos diários | Compras diárias |  Acessos em horários de pico | Acessos madrugada
----- | ------ | ---- | ----- | -------
Dias normais | 40000 | 2000 | 4000 | 200 
Dias das mães | 60000 | 2500 | 5700 | 250
Dias dos pais | 49000 | 2150 | 4400 | 220
Dias dos namorados | 51000 | 2250 | 4700 |230
Black Friday | 82000 | 5500 | 7500 | 470
Natal | 67000 | 2900 | 6000 | 300

## Problemas enfrentados
<hr>

Hoje Cloud Shoes passa por alguns problemas relacionados a estrutura e performance do seu principal workload, isso em alguns momentos tem trazido perda de vendas e até uma preferência dos usuários por outras lojas concorrentes.
Principais problemas encontrados:
- Nota-se períodos de grande lentidão no acesso dos clientes, principalmente para abrir imagens de produtos;
- Em determinados dias, nota-se a falta de recursos em alguns servidores nos horários de picos e durante a
madrugada um consumo de menos de 10%, em média;
- Dificuldade de analisar (monitorar) quais são os produtos mais acessados do site e tempo de resposta nas
páginas mais acessadas;
- Problemas de compliance relativo ao equipamento de firewall que publica a aplicação externamente, por não
possuir a feature de WAF;
- Necessidade de um grande esforço manual da equipe para provisionar novos servidores durante períodos de
maior acesso/vendas. Posteriormente, todos os recursos provisionados relativos a servidores precisam ser
deletados manualmente para liberar hardware;

## Principais problemas encontrados
<hr>

- O servidor de integração executa uma aplicação legada, onde roda serviços de processamento assíncrono que
integra dados de compras e NFEs com o ERP. Essa aplicação possui dependências de serviços do Windows e
algumas COM+. Esse servidor não possui balanceamento de carga devido sobrecarga do único balanceador
de carga interno. A Cloud Shoes aguarda a compra de um novo balanceador de carga interno para adicionar
um novo servidor a esse serviço;
- Alto custo de armazenamento para imagens do catálogo antigas ou que não estão sendo usadas. Storage
atual não possui um modelo de disco mais barato para “tierizar” essas imagens sem uso;
- O backup de todos os dados da aplicação e banco de dados, são realizados em um storage e mantidos por 15
dias para restore rápido. Passado esse período, são enviados para fitas de backup, coletados levados para um
cofre fora da estrutura, dificultando o restore de dados maiores de 15 dias.

## Necessidades
<hr>
Hoje a Cloud Shoes, tem em seu planejamento estratégico uma meta de migrar 70% de suas aplicações para cloud
nos próximos dois anos. O provedor eleito foi o Azure, devido a seu ambiente ser 90% Microsoft e ter uma maior familiaridade técnica da equipe de infraestrutura, banco de dados e aplicações. A migração para cloud, tem como objetivo sanar alguns problemas vivenciados hoje no ambiente local:

- Reduzir custos relacionados a renovação de servidores e garantia de equipamentos;
- Entregar maior poder de escalabilidade em datas de maior demanda do comércio;
- Otimizar o uso de recursos em períodos de baixa demanda;
- Utilizar novas tecnologias que possam melhorar a performance na experiência de acesso, navegação e
compra para o usuário final;
- Reduzir o esforço administrativo da equipe de infraestrutura de servidores;
- Aumentar a segurança relativa a exposição do e-commerce;
- Reduzir o tempo para restore de dados com mais de 15 dias;
- Possibilitar no futuro que os clientes realizem autenticação no formato B2C usando do google, Microsoft e demais provedores;
- Maior monitoramento sobre acessos, principais produtos e tempos de resposta;
- Reduzir custo de armazenamento para imagens do catálogo antigas (sem uso no momento).

## Sobre a migração para Cloud
<hr>

Hoje Cloud Shoes não tem nenhuma estrutura de produção no Azure. Possui uma assinatura PAYGO no Azure basicamente sem consumo. A Cloud Shoes já possui replicação dos usuários do AD local com Azure AD, devido a utilização de serviços do Microsoft 365, como Exchange Online, OneDrive e Teams.
- Não existe nenhuma conexão física entre o ambiente local e o Azure;
- Todos os servidores Windows da Cloud Shoes fazem parte do domínio cloudshoes.local, onde existem 2
servidores de Active Diretory com zonas de DNS integradas;
- Toda a autenticação dos clientes externos para realizar a compra é feita diretamente em uma estrutura do banco de dados SQL Server;
- Toda estrutura do E-commerce não possui dependência de outros workloads (exceto estrutura de AD e DNS);
Apenas o servidor de integração que precisa se comunicar com a estrutura do ERP para transportar dados relativos a vendas e NFEs;
- Nessa etapa do projeto, estimasse a migração somente do workload E-Commerce.


## Sobre a proposta
<hr>

A Cloud Shoes deseja receber de parceiros uma proposta para migração do seu E-Commerce para o Azure.
Essa primeira etapa da proposta deve conter os seguintes itens:

- Desenho de arquitetura para a solução no Azure;
- Breve descrição dos principais serviços utilizados na solução e abordar principais vantagens para escolha dessa
solução;
- Precificação da solução (montar dois cenários: 1° somente com pagamento mensal. 2° usar instância
reservada de 3 anos para serviços possíveis);
- Cronograma para migração do workload e configurações necessárias no ambiente Azure/Cloud Shoes;
- Precificar o valor de investimento para realização do projeto (consultoria).