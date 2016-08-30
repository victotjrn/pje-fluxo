#Fluxos processuais no PJe do TJRN

Fluxos processuais do primeiro e segundo graus no PJe do Tribunal de Justiça do Rio Grande do Norte.

Atenção
-------
Fluxos no formato XML carregam eventos de tarefa, nem o conteúdo da label das variáveis. Logo, ao inserir um fluxo pela primeira vez na aplicação, verifique a necessidade de criação de seus eventos de tarefas, quando houver a presença da EL <kbd>#{lancadorMovimentosService.setCondicaoLancamentoMovimentosTemporarioNoFluxo('#{true}')}</kbd> nos nós de tarefa, bem como ajustes nas labels das variáveis para conter suas respectivas denominações.


## **Procedimentos para desenvolvimento de fluxo no PJe**

Algumas convenções foram definidas, a fim de manter uma padronização na criação e manutenção dos fluxos do PJe. Abaixo, seguem as principais.

### **Código em fluxos**

O código do fluxo é definido com o seguinte formato:

> **Padrão:** SIGLA\_INICIAIS\_DO\_NOME\_DO\_FLUXO

> **Exemplo:** SG\_FBG

O trecho onde tem **SG\_**, indica a sigla do fluxo, que nesse refere-se um fluxo do segundo grau, logo em seguida, vem as iniciais do nome do fluxo (Fluxo básico de conhecimento) separados por underline.

> **Atenção!** Códigos dos fluxos não permitem espaços e caracteres especiais.

### **Nome em fluxos**

O nome do fluxo é semelhante ao código, porém com um texto mais amigável.

> **Padrão:** (SIGLA) Nome completo do fluxo

> **Exemplo:** (SG) Fluxo básico de conhecimento

> **Atenção!** 
- Nomes de fluxos **permitem espaços, acentos, mas não os demais caracteres especiais**.
- Devem ser **iniciados com letra maiúscula**, e o **restante com letras minúsculas**, conforme exemplo acima.

### **Raias**

As raias são utilizadas nos nós de tarefas e resumem-se na combinação de localização e papel.

Todo fluxo traz consigo uma raia com nome "**Nó de Desvio - NOME DO FLUXO**". Essa raia **não é utilizada**, pois em nosso ambiente, o **nó de desvio encontra-se desabilitado**. Ele tem sido responsável por alguns processos no limbo e por quebrar o controle das variáveis de controle criadas nos nós do fluxo.

**Para desabilitar a raia nó de desvio do fluxo através da aba XML, substitua o conteúdo da tag swimlane pela linha presente abaixo:**
```
    <swimlane name="Nó de Desvio - NOME DO FLUXO">
        <assignment actor-id="#{actor.id}"/>
    </swimlane>
```

### **Ordenação dos nós**
Ao criar os nós, é importante mantê-los na ordem da sequência lógica do fluxo, a fim de 
facilitar a manutenção.

### **Nome em nós**
Os nomes dos nós são definidos de forma semelhante ao nome dos fluxos:

> **Padrão**: (SIGLA) Nome do nó

> **Exemplo**: (SG) Lançar movimentação conclusos para decisão

#### **Nome em nós de tarefa**
Os nós de tarefa seguem a notação básica de nomenclaturas de nós, sendo que ao nomear o nó, além da sigla precedendo o seu nome, segue o padrão abaixo:

> **Padrão**: (SIGLA) FASE - AÇÃO

> **Exemplo**: (SG) Conclusos para decisão - MINUTAR

No exemplo acima, temos a sigla **(SG)** que indica que é um fluxo do segundo grau, **Conclusos para decisão** que é a fase em que o processo se encontra naquela tarefa (no gabinete), por fim, **MINUTAR** indicando ação que deverá ser feita pelo usuário, uma vez que todo nó de tarefa espera por uma ação do usuário ou sistema.

A **ação** é indicada por um **verbo no infinitivo e em caixa alta** (MINUTAR, ANALISAR, etc).

> **Atenção!** _Não é permitido criar nós de tarefa com o mesmo nome, mesmo que em fluxos diferentes._

#### **Nome em nós de decisão**
Os nós de decisão vem sempre acompanhado por uma interrogação no final, que indica se a condição que está sendo verificada será atendida ou não.

> **Padrão**: (SIGLA) Nome do nó?

> **Exemplo**: (SG) Tem pedido de urgência?

#### **Nome em nós de separação ou junção**
Vem sempre acompanhado pelo nome "Separação em" ou "Junção em".

> **Padrão**: (SIGLA) Separação em NOME ou (SIGLA) Junção em NOME

> **Exemplo**: (SG) Separação em controle de prazo ou (SG) Junção em controle de prazo

No exemplo acima, trata-se de uma separação e junção no fluxo de controle de prazo.

#### **Nome em nós de SubProcesso**
Segue a notação padrão dos nós.

#### **Nome em nós de sistema**
Seus nomes iniciam sempre com um verbo no infinitivo.

> **Padrão**: (SIGLA) Verbo + nome do nó

> **Exemplo**: (SG) Registrar movimento de conclusos para decisão

### **Label em variáveis criadas através do assistente**
Como as **labels das variáveis que são criadas através do assistente de criação e manutenção de fluxo não são gravados no XML do fluxo**, se faz necessário alterá-las para não ficar com nomes estranhos que são criados pelo próprio sistema.

A maioria das variáveis não fazem uso de label, já outras precisam ter suas labels definidas para facilitar sua visualização pelo usuário, tais como **Editor**, **Checkbox**, **Aviso**, **Radio Sim/Não**, **Texto**, **Numérico**, **Combo Sim/Não**, **Combo de objetos**, **Data** e **Data passada**.

É necessário que **sejam documentadas todas as variáveis de tarefas criadas pelo assistente** na área de **Descrição** da tarefa, seguindo o padrão exemplificado abaixo:

```
*Variáveis*

1. Variável: movimentacaoLote
   Label:
   Escrita: Sim
   Obrig.: Não
   Tipo: Habilitar Movimentação em Lote

2. Variável: WEB-INF_xhtml_flx_visualizarPeticao
   Label:
   Escrita: Sim
   Obrig.: Não
   Tipo: Frame
```

> **Importante!** 
- Variáveis que **não necessitam de labels**, ficam com **labels vazias**.
- As que **necessitam de label**, devem também ter sua **documentação registrada na área "Descrição" da tarefa**, conforme dito anteriormente.

### **Eventos**
Os eventos são utilizados de acordo com o tipo de nó e a operação que está sendo feita nele.

#### **Evento em nó de tarefa**
Quase sempre as ações são referenciadas aos eventos **Criar tarefa**, **Finaliza tarefa**, **Iniciar tarefa** e **Atribuir tarefa**.

> _**Criar tarefa**_ quando deseja criar alguma variável ou registrar alguma EL quando o processo entrar na tarefa.

> _**Finalizar tarefa**_ quando desejamos fazer alguma operação, geralmente exclusão de uma variável no contexto da tarefa.

> _**Iniciar tarefa**_ para os casos de preparação de minuta quando se usa "Eventos de tarefa", bem como na utilização da EL ```#{tipoDocumento.set('TipoDocumento',1,2,3)}```, que necessitam que esteja nesse tipo de evento.

> _**Atribuir tarefa**_ quando necessita que a EL seja reexecutada completamente toda vez que a tarefa for aberta pelo usuário.

#### **Evento em nó de decisão**
Eventos dos tipos **Entrar no nó** e **Sair do nó** funcionam normalmente. No entanto, **não é uma boa prática utilizar eventos em nós de decisão**, pois eles ficam escondidos, podendo dificultar a manutenção do fluxo.

**Recomendamos que seja criado um Nó de sistema** para que fique explícito que existe uma ou várias ações a serem executadas naquele nó.

#### **Evento em nós de separação e junção**
Eventos dos tipos **Entrar no nó** e **Sair do nó** funcionam normalmente. No entanto, **não é uma boa prática utilizar eventos em nós de separação e junção**, pois eles ficam escondidos, podendo dificultar a manutenção do fluxo.

**Recomendamos que seja criado um Nó de sistema** para que fique explícito que existe uma ou várias ações a serem executadas naquele nó.

#### **Evento em nós de SubProcesso**
Eventos dos tipos **Entrar no nó** e **Sair do nó** são utilizados normalmente para envio de variáveis que serão controladas no fluxo que está referenciado ao nó.

#### **Evento em nós de Sistema**
Normalmente utilizamos apenas o evento **Entrar no nó** para registrar ou executar alguma ação nesses tipos de nós.

### **Criação de variável no contexto do fluxo**
Ao criar variável no contexto fluxo (```#{tramitacaoProcessualService.gravaVariavel('nome', 'valor')}```), é importante que ela seja apagada (```#{tramitacaoProcessualService.apagaVariavel('nome')}```) em algum momento. Seja em um nó no próprio fluxo, ou em um nó do fluxo pai, avó, etc.

### **Criação de variável no contexto da tarefa**
Ao criar variável no contexto da tarefa (```#{tramitacaoProcessualService.gravaVariavelTarefa('nome', 'valor')}```), lembrar sempre de apagá-la (```#{tramitacaoProcessualService.apagaVariavelTarefa('nome')}```) no evento **Finalizar tarefa**, a fim de não deixar as tabelas do jbpm poluídas com registros que não serão mais utilizados.
