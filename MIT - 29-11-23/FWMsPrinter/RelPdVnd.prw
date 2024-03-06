#INCLUDE 'TOTVS.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'FWPRINTSETUP.CH'
#INCLUDE 'RPTDEF.CH' //? Biblioteca com alguns recursos para relatórios do Protheus

#DEFINE PRETO      RGB(000,000,000)
#DEFINE MAX_LINE   760
#DEFINE incremento 15

/*/{Protheus.doc} User Function RelPdVnd
    Exercício | Relatório de Pedido de Venda 
    @type  Function
    @author André Lucas
    @since 29/11/2023
    @version 0.1
    @see https://tdn.totvs.com/display/public/framework/FWMsPrinter
/*/

User Function RelPdVnd()

    Private aColRetrato  := {15 ,35 ,70 ,105,155,180,220,265,290,315,340,380,405,445,470,495,520,550,580 }
    Private aColPaisagem := {15 ,50 ,95 ,145,245,275,325,385,420,455,495,550,605,655,685,715,745,775,825 }
    Private nOpcao
    Private cAlias
    Private cAlias2
    Private lQuebPag  := .F.
    Private cPedidos  := ""
    Private nLinAntes := 0
    Private aParam    := {}
    Private oPrint
    Private oPrintModelo
    Private oPrintVazio

    TelConfigPrint()

    TelOpcoes()

Return 

Static Function TelConfigPrint()

    Local cArquivo := 'RelatorioAnaliseCritica2.pdf'

    oPrintModelo := FwMsPrinter():New(cArquivo,IMP_PDF, .F., '', .F.,, @oPrintModelo, '',,,,.T.)
    aParam := aClone(TelPerguntas())

Return

Static Function TelPerguntas()
    Local cPergunta     := "ZZRELPDVND"
    Local aRetorno      := {}
    Local lConfirma     := .F.

    lConfirma := Pergunte(cPergunta, .T.)

    if lConfirma
        AADD(aRetorno,MV_PAR01)
        AADD(aRetorno,MV_PAR02)
        AADD(aRetorno,MV_PAR03)
        AADD(aRetorno,MV_PAR04)
    endif

Return aRetorno

Static Function TelOpcoes()

    Local oDlg

    DEFINE MSDIALOG oDlg TITLE 'Pedido de Vendas' FROM 000,000 TO 100,330 PIXEL
    @ 010,010 SAY 'Relatório de Pedido de Vendas' SIZE 100,20 OF oDlg PIXEL
    @ 030,010 BUTTON 'Configurar'                 SIZE 030,015 OF oDlg ACTION (TelConfigPrint()) PIXEL 
    @ 030,050 BUTTON 'Imprimir'                   SIZE 030,015 OF oDlg ACTION (nOpcao := 1, PrintRelat(cAlias,cAlias2,aParam),oDlg:End()) PIXEL 
    @ 030,090 BUTTON 'Visualizar'                 SIZE 030,015 OF oDlg ACTION (nOpcao := 2, PrintRelat(cAlias,cAlias2,aParam)) PIXEL 
    @ 030,130 BUTTON 'Sair'                       SIZE 030,015 OF oDlg ACTION (nOpcao := 3, oDlg:End()) PIXEL 

    ACTIVATE MSDIALOG oDlg CENTERED

Return nOpcao

Static Function PrintRelat(cAlias,cAlias2,aParam)

    Local cArquivo := 'RelatorioAnaliseCritica2.pdf'

    if len(aParam)>0
        cAlias := ConstrCabec(aParam)
    else
        cAlias := ''
    endif

    if cAlias <> ''
        cAlias2 := ConstrItens()
    endif
    if nOpcao <> 3
        if nOpcao == 2
            oPrint := FwMsPrinter():New(cArquivo,IMP_PDF, .F., '', .T.,, @oPrintVazio, '',,,,.T.)

            if oPrintModelo:GetOrientation() == 1
                oPrint:SetPortrait()
            else
                oPrint:SetLandscape()
            endif
        elseif nOpcao == 1
            oPrint := oPrintModelo
        endif
        
        oPrint:SetPaperSize(9)
        
        if !Empty(cAlias)
            Processa({|| MontaRelat(cAlias,cAlias2)}, 'Aguarde...', 'Imprimindo Relatório')
        
            if nOpcao == 1
                oPrint:Print()
            elseif nOpcao == 2
                oPrint:Preview()
            endif

            if nOpcao == 2
                oPrint := FwMsPrinter():New(cArquivo,IMP_PDF, .F., '', .T.,, @oPrintModel, '',,,,.T.)
            endif

            (cAlias)->(DbCloseArea())
            (cAlias2)->(DbCloseArea())
        else
            FwAlertError('Nenhum Registro encontrado para os parâmetros informados!', 'Atenção!')
        endif
    endif

Return

Static Function ConstrCabec(aParam)

    Local aArea     := GetArea()
    Local aAreaSC5  := SC5->(GetArea())
    Local cAlias    := GetNextAlias()
    Local cQuery    := ''
    Local cPedDe    := Alltrim(aParam[1])
    Local cPedAte   := Alltrim(aParam[2])
    Local cDataDe   := Alltrim(DtoS(aParam[3]))
    Local cDataAte  := Alltrim(DtoS(aParam[4]))
    Local cIniPed   := ''
    Local cUltPed   := ''

    //? Retorna: Primeiro e Ultimo Pedido
    DbSelectArea('SC5')
    DbSetOrder(1)
    SC5->(DbGoTop())
    cIniPed := SC5->(C5_NUM)
    SC5->(DbGoBottom())
    cUltPed := SC5->(C5_NUM)

    cQuery += " SELECT SC5.C5_NUM,SC5.C5_EMISSAO,SC5.C5_ZZPDCLI,SC5.C5_ZZDTEMB,SC5.C5_FECENT,SC5.C5_ZZNCONT, SC5.C5_ZZOBPED, " + CRLF
    cQuery += " SA1.A1_COD, SA1.A1_LOJA, SA1.A1_NOME, SA1.A1_CGC FROM " + RetSqlName('SC5') + " SC5 " + CRLF
    cQuery += " INNER JOIN " + RetSqlName('SA1') + " SA1 ON SA1.A1_COD = SC5.C5_CLIENTE AND SA1.D_E_L_E_T_ = ' ' AND SA1.A1_FILIAL = '" + xFilial('SA1') + "' " + CRLF
    cQuery += " WHERE SC5.D_E_L_E_T_ = ' ' AND SC5.C5_FILIAL = '" + xFilial('SC5') + "' " + CRLF

    if cPedDe <> ''
        if cPedAte <> ''
            cQuery +=  " AND (SC5.C5_NUM BETWEEN '" + aParam[1] + "' AND '"  + aParam[2] + "') " + CRLF
        else
            cQuery +=  " AND (SC5.C5_NUM BETWEEN '" + aParam[1] + "' AND '"  + cUltPed + "') " + CRLF //? PedAte vazio utiliza o último pedido!
        endif
    else
        if cDataDe == ''
            cQuery +=  " AND (SC5.C5_NUM = '"  + SC5->(C5_NUM) + "') " + CRLF //? Se PedDe em branco utiliza pedido posicionado na rotina padrão!
        endif
    endif

    if cDataDe <> ''
        if cDataAte <> ''
            cQuery +=  " AND (CONVERT(VARCHAR,SC5.C5_EMISSAO,112) BETWEEN '" +DtoS(aParam[3])+ "' AND '" + DtoS(aParam[4]) + "') " + CRLF
        else
            cQuery +=  " AND (CONVERT(VARCHAR,SC5.C5_EMISSAO,112) BETWEEN '" +DtoS(aParam[3])+ "' AND '" + DtoS(Date()) + "') " + CRLF
            //? Se DataDe preenchida e DataAte em branco utiliza como data a data atual do sistema Protheus!
        endif
    endif

    cQuery += " ORDER BY SC5.C5_EMISSAO, SC5.C5_NUM " + CRLF


    TCQUERY cQuery ALIAS (cAlias) NEW

    (cAlias)->(DbGoTop())

    if (cAlias)->(EOF())
        cAlias := ''
        cPedidos := ''
    else
        cPedidos  := "("
        while (cAlias)->(!EOF())
            cPedidos += "'" + (cAlias)->(C5_NUM) + "'"
            (cAlias)->(DbSkip())
            if (cAlias)->(!EOF())
                cPedidos += ','
            else
                cPedidos += ')'
            endif
        enddo
        (cAlias)->(DbGoTop())
    endif

    RestArea(aAreaSC5)
    RestArea(aArea)

Return cAlias

Static Function ConstrItens()

    Local aArea     := GetArea()
    Local cAlias2   := GetNextAlias()
    Local cQuery    := ''

    cQuery += " SELECT SC6.C6_NUM, SC6.C6_ITEMPC, SC6.C6_ZZPRCLI, SC6.C6_PRODUTO, SC6.C6_DESCRI, SC6.C6_QTDVEN, SC6.C6_ZZDESEN, SC6.C6_ZZESPEC, (SC6.C6_QTDVEN - SC6.C6_QTDENT) 'RELACAOQTD', " + CRLF
    cQuery += " SC6.C6_ZZQTEMB, SC6.C6_ZZTPEMB, SC6.C6_ZZMEDID, SC6.C6_ZZLOTE, SC6.C6_ZZRELAT, SC6.C6_ZZPELIQ, SC6.C6_ZZPEBRU, SC6.C6_ZZPETOT, SC6.C6_NOTA, SC6.C6_ZZOBSEV FROM " + RetSqlName('SC6') + " SC6 " + CRLF
    cQuery += " WHERE SC6.D_E_L_E_T_ = ' ' AND SC6.C6_FILIAL = '" + xFilial('SC6') + "' " + CRLF

    if cPedidos <> ''
        cQuery += " AND SC6.C6_NUM IN " + cPedidos + CRLF //? Se pedidos diferente de vazio utiliza o número do item presente em pedidos selecionados pelo Cabeçalho dos Itens!  
    endif

    cQuery += " ORDER BY SC6.C6_NUM, SC6.C6_PRODUTO " + CRLF

    TCQUERY cQuery ALIAS (cAlias2) NEW

    (cAlias2)->(DbGoTop())

    if (cAlias2)->(EOF())
        cAlias2 := ''
    endif

    RestArea(aArea)

Return cAlias2

Static Function MontaRelat(cAlias,cAlias2)

    Private nComprimento := 580
    Private nLinha       := 145
    Private lRetrato     := .F.
    Private lPaisagem    := .F.
    Private oFont10      := TFont():New('Arial',,10,, .F.,,,,,.F.,.F.)
    Private oFont10B     := TFont():New('Arial',,10,, .T.,,,,,.F.,.F.)
    Private oFont12      := TFont():New('Arial',,12,, .F.,,,,,.F.,.F.)
    Private oFont12B     := TFont():New('Arial',,12,, .T.,,,,,.F.,.F.)
    Private oFont14      := TFont():New('Arial',,14,, .F.,,,,,.F.,.F.)
    Private oFont14B     := TFont():New('Arial',,14,, .T.,,,,,.F.,.F.)
    Private oFont16      := TFont():New('Arial',,16,, .F.,,,,,.F.,.F.)
    Private oFont16B     := TFont():New('Arial',,16,, .T.,,,,,.F.,.F.)

    if oPrint:GetOrientation() == 1
        nComprimento := 580
        lRetrato := .T.
    else
        nComprimento := 825
        lPaisagem := .T.
    endif

    (cAlias)->(DbGoTop())

    while (cAlias)->(!EOF())
        nLinha := 145
        oPrint:StartPage()
        SetInfoRelat(cAlias)
        SetCabecPdVnd(cAlias,nComprimento)
        if oPrint:GetOrientation() == 1
            SetItensRetr(cAlias,cAlias2)
        else
            SetItensPaisg(cAlias,cAlias2)
        endif

        oPrint:EndPage()
        (cAlias)->(DBSkip())
    enddo

Return

Static Function SetInfoRelat(cAlias)

    oPrint:SayBitmap( 15, 15, "\system\LGMID.png", 200, 75)


    oPrint:SayAlign(15, 10, 'ASW BRASIL TECNOLOGIA EM PLÁSTICOS LTDA'                        , oFont14B , (nComprimento - 10) ,,, 1)
    oPrint:SayAlign(30, 10, 'RUA ADEMAR BOMBO, 380, PQ. INDUSTRIAL, MOGI GUAÇU/SP 13849-224' , oFont12  , (nComprimento - 10) ,,, 1)
    oPrint:SayAlign(45, 10, 'E-mail: vendas@asw.com.br; comercial@aswbrasil.com.br'          , oFont12B , (nComprimento - 10) ,,, 1)
    oPrint:SayAlign(60, 10, 'Fone: (19) 3851-3100'                                           , oFont14  , (nComprimento - 10) ,,, 1)
    oPrint:SayAlign(75, 10, 'CNPJ: 09.662.563/0001-10 IE: 455.183.546.113'                   , oFont14  , (nComprimento - 10) ,,, 1)

    oPrint:Line(90,15,90,nComprimento,,'-8')
    oPrint:SayAlign(95, 15, 'ANÁLISE CRITICA 2', oFont16B  ,  (nComprimento - 15) ,,, 2)

    oPrint:Line(115,15,115,nComprimento,,'-8')
    oPrint:SayAlign(120, 15, 'Pedido N° ' + Alltrim((cAlias)->(C5_NUM)), oFont14B  ,  (nComprimento - 15) ,,, 0)
    oPrint:SayAlign(120, 15, 'Data: ' + TRANSFORM(StoD((cAlias)->(C5_EMISSAO)), '@R 99/99/9999'), oFont14B  ,  (nComprimento - 15) ,,, 1)

    oPrint:Line(135,15,135,nComprimento,,'-8')

Return

Static Function SetCabecPdVnd(cAlias,nComprimento)

    Local nColCabec1 := 15
    Local nColCabec2 := 100
    Local nColCabec3 := (nComprimento/2)
    Local nColCabec4 := nColCabec3 + 70
    Local nColCabec5 := nColCabec4 + 85
    Local nColCabec6 := nColCabec5 + 55
    Local cCliente   := ''
    Local nQtd       := 1

    if nComprimento > 580
        nColCabec5 := (nComprimento*2/3) + 70
        nColCabec6 := nColCabec5 + 55
    endif

    //? Impressão Dados do Pedido - Cabeçalho dos Itens do Pedido
    oPrint:Say(nLinha,nColCabec1, 'Cliente:' ,oFont12B,,PRETO)
    cCliente := Alltrim((cAlias)->(A1_COD)) + ' - ' + Alltrim((cAlias)->(A1_LOJA)) + ' - ' + Alltrim((cAlias)->(A1_NOME))
    oPrint:Say(nLinha,nColCabec2, cCliente,oFont12,,PRETO)
    oPrint:Say(nLinha,nColCabec3, 'CNPJ' ,oFont12B,,PRETO)
    oPrint:Say(nLinha,nColCabec4, TRANSFORM(Alltrim((cAlias)->(A1_CGC)),'@R 99.999.999/9999-99'),oFont12,,PRETO)
    nLinha += nQtd * incremento
    oPrint:Say(nLinha,nColCabec1, 'N° Pedido Cliente: ' ,oFont12B,,PRETO)
    oPrint:Say(nLinha,nColCabec2, Alltrim((cAlias)->(C5_ZZPDCLI)),oFont12,,PRETO)
    oPrint:Say(nLinha,nColCabec3, 'Dt. Embarque: ' ,oFont12B,,PRETO)
    oPrint:Say(nLinha,nColCabec4, TRANSFORM(StoD((cAlias)->(C5_ZZDTEMB)), '@R 99/99/9999'),oFont12,,PRETO)
    oPrint:Say(nLinha,nColCabec5, 'Dt. Entrega: ' ,oFont12B,,PRETO)
    oPrint:Say(nLinha,nColCabec6,  TRANSFORM(StoD((cAlias)->(C5_FECENT)), '@R 99/99/9999'),oFont12,,PRETO)
    nLinha += incremento
    oPrint:Say(nLinha,nColCabec1, 'N° Contrato' ,oFont12B,,PRETO)
    oPrint:Say(nLinha,nColCabec2, Alltrim((cAlias)->(C5_ZZNCONT)),oFont12,,PRETO)
    nLinha += 10

Return

Static Function QuebLnCabec(cString, nQtdCar, nCol, oFont, nQtd)

    if lRetrato
        nQtd := QbraRetLinha(cString, nQtdCar, nCol, oFont)
    elseif lPaisagem
        nQtd := QbraPsgLinha(cString, nQtdCar, nCol, oFont, 0, 150)
    endif

Return nQtd

//? VERTICAL - RETRATO

Static Function SetItensRetr(cAlias,cAlias2)

    //? Imprime os Dados de Itens do Relatório no modelo Retrato
    Local nQtdLinhas  := 0
    Local nQtdMaior   := 0
    Local cString     := ''
    Local nCont       := 1
    Private nCor      := PRETO

    DbSelectArea(cAlias)

    //? Imprime Cabeçalho dos Itens 
    nLinAntes := CabecRetItens(cAlias)

    (cAlias2)->(DbGoTop())
    //? Imprime os Dados dos Itens
    while (cAlias2)->(!EOF())
        if (cAlias)->(C5_NUM) == (cAlias2)->(C6_NUM)
            nQtdMaior := 1
            nLinha += 10

            //? Impressão dos Campos e Quebra de Linhas
            cString := Alltrim((cAlias2)->(C6_ITEMPC))
            nQtdLinhas := QbraRetLinha(cString,5,16,oFont10)
            nQtdMaior  := VerMaiorLinha(nQtdMaior,nQtdLinhas)

            cString := Alltrim((cAlias2)->(C6_ZZPRCLI))
            nQtdLinhas := QbraRetLinha(cString,6,37,oFont10)
            nQtdMaior  := VerMaiorLinha(nQtdMaior,nQtdLinhas)

            cString := Alltrim((cAlias2)->(C6_PRODUTO))
            nQtdLinhas := QbraRetLinha(cString,8,71,oFont10)
            nQtdMaior  := VerMaiorLinha(nQtdMaior,nQtdLinhas)

            cString := Alltrim((cAlias2)->(C6_DESCRI))
            nQtdLinhas := QbraRetLinha(cString,10,106,oFont10)
            nQtdMaior  := VerMaiorLinha(nQtdMaior,nQtdLinhas)

            cString := CValToChar((cAlias2)->(C6_QTDVEN))
            nQtdLinhas := QbraRetLinha(cString,3,157,oFont10)
            nQtdMaior  := VerMaiorLinha(nQtdMaior,nQtdLinhas)

            cString := Alltrim((cAlias2)->(C6_ZZDESEN))
            nQtdLinhas := QbraRetLinha(cString,8,182,oFont10)
            nQtdMaior  := VerMaiorLinha(nQtdMaior,nQtdLinhas)

            cString := Alltrim((cAlias2)->(C6_ZZESPEC))
            nQtdLinhas := QbraRetLinha(cString,10,221,oFont10)
            nQtdMaior  := VerMaiorLinha(nQtdMaior,nQtdLinhas)

            cString := CValToChar((cAlias2)->(RELACAOQTD))
            nQtdLinhas := QbraRetLinha(cString,4,266,oFont10)
            nQtdMaior  := VerMaiorLinha(nQtdMaior,nQtdLinhas)

            cString := CValToChar((cAlias2)->(C6_ZZQTEMB))
            nQtdLinhas := QbraRetLinha(cString,3,291,oFont10)
            nQtdMaior  := VerMaiorLinha(nQtdMaior,nQtdLinhas)

            cString := Alltrim((cAlias2)->(C6_ZZTPEMB))
            nQtdLinhas := QbraRetLinha(cString,4,316,oFont10)
            nQtdMaior  := VerMaiorLinha(nQtdMaior,nQtdLinhas)

            cString := Alltrim((cAlias2)->(C6_ZZMEDID))
            nQtdLinhas := QbraRetLinha(cString,8,341,oFont10)
            nQtdMaior  := VerMaiorLinha(nQtdMaior,nQtdLinhas)

            cString := Alltrim((cAlias2)->(C6_ZZLOTE))
            nQtdLinhas := QbraRetLinha(cString,4,381,oFont10)
            nQtdMaior  := VerMaiorLinha(nQtdMaior,nQtdLinhas)

            cString := Alltrim((cAlias2)->(C6_ZZRELAT))
            nQtdLinhas := QbraRetLinha(cString,8,406,oFont10)
            nQtdMaior  := VerMaiorLinha(nQtdMaior,nQtdLinhas)

            cString := CValToChar((cAlias2)->(C6_ZZPELIQ))
            nQtdLinhas := QbraRetLinha(cString,4,447,oFont10)
            nQtdMaior  := VerMaiorLinha(nQtdMaior,nQtdLinhas)

            cString := CValToChar((cAlias2)->(C6_ZZPEBRU))
            nQtdLinhas := QbraRetLinha(cString,4,472,oFont10)
            nQtdMaior  := VerMaiorLinha(nQtdMaior,nQtdLinhas)

            cString := CValToChar((cAlias2)->(C6_ZZPETOT))
            nQtdLinhas := QbraRetLinha(cString,4,497,oFont10)
            nQtdMaior  := VerMaiorLinha(nQtdMaior,nQtdLinhas)

            cString := Alltrim((cAlias2)->(C6_NOTA))
            nQtdLinhas := QbraRetLinha(cString,5,521,oFont10)
            nQtdMaior  := VerMaiorLinha(nQtdMaior,nQtdLinhas)

            cString := Alltrim((cAlias2)->(C6_ZZOBSEV))
            nQtdLinhas := QbraRetLinha(cString,6,551,oFont10)
            nQtdMaior  := VerMaiorLinha(nQtdMaior,nQtdLinhas)

            nLinha += nQtdMaior * 10
            oPrint:Line(nLinha, 15  , nLinha ,580  ,,'-6')
            QuebraPagina(nLinAntes, cAlias, cAlias2)
        endif
        (cAlias2)->(DbSkip())
    enddo
    (cAlias2)->(DbGoTop())

    if lQuebPag
        nLinAntes := 145
    endif

    //? Imprime as Linhas Verticais
    for nCont := 1 TO 19
        oPrint:Line(nLinAntes, aColRetrato[nCont]  , nLinha ,aColRetrato[nCont]  ,,'-6')
    next

    oPrint:Line(nLinha, 15, nLinha ,580,,'-6')

    nLinha += 10

Return

Static Function CabecRetItens(cAlias)

    Local nLinAntes

    oPrint:Box(nLinha,15  ,nLinha+36,580,'-6')
    nLinAntes := nLinha
    oPrint:SayAlign(nLinha, 17 , 'Item'                   , oFont10B ,  18  ,,, 0)
    oPrint:SayAlign(nLinha, 37 , 'Cod.'                   , oFont10B ,  33  ,,, 0)
    oPrint:SayAlign(nLinha, 72 , 'Produto'                , oFont10B ,  43  ,,, 0)
    oPrint:SayAlign(nLinha, 107, 'Descrição'              , oFont10B ,  48  ,,, 0)
    oPrint:SayAlign(nLinha, 157, 'Qtd.'                   , oFont10B ,  23  ,,, 0)
    oPrint:SayAlign(nLinha, 182, 'Desenho'                , oFont10B ,  38  ,,, 0)
    oPrint:SayAlign(nLinha, 222, 'Especific.'             , oFont10B ,  43  ,,, 0)
    oPrint:SayAlign(nLinha, 267, 'Qtd.'                   , oFont10B ,  23  ,,, 0)
    oPrint:SayAlign(nLinha, 292, 'Qtd.'                   , oFont10B ,  23  ,,, 0)
    oPrint:SayAlign(nLinha, 317, 'Tipo'                   , oFont10B ,  23  ,,, 0)
    oPrint:SayAlign(nLinha, 342, 'Medidas'                , oFont10B ,  38  ,,, 0)
    oPrint:SayAlign(nLinha, 382, 'Lote'                   , oFont10B ,  23  ,,, 0)
    oPrint:SayAlign(nLinha, 407, 'Relatório'              , oFont10B ,  38  ,,, 0)
    oPrint:SayAlign(nLinha, 447, 'Peso'                   , oFont10B ,  23  ,,, 0)
    oPrint:SayAlign(nLinha, 472, 'Peso'                   , oFont10B ,  23  ,,, 0)
    oPrint:SayAlign(nLinha, 497, 'Peso'                   , oFont10B ,  23  ,,, 0)
    oPrint:SayAlign(nLinha, 522, 'N° NF'                  , oFont10B ,  30  ,,, 0)
    oPrint:SayAlign(nLinha, 552, 'Obs.'                   , oFont10B ,  30  ,,, 0)
    nLinha += 10 
    oPrint:SayAlign(nLinha, 17 , 'Cli.'                   , oFont10B ,  18  ,,, 0)
    oPrint:SayAlign(nLinha, 37 , 'Prd.'                   , oFont10B ,  33  ,,, 0)
    oPrint:SayAlign(nLinha, 267, 'Pç'                     , oFont10B ,  23  ,,, 0)
    oPrint:SayAlign(nLinha, 292, 'Emb.'                   , oFont10B ,  23  ,,, 0)
    oPrint:SayAlign(nLinha, 317, 'Emb.'                   , oFont10B ,  23  ,,, 0)
    oPrint:SayAlign(nLinha, 342, '(AxLxC)'                , oFont10B ,  38  ,,, 0)
    oPrint:SayAlign(nLinha, 407, 'CQ'                     , oFont10B ,  38  ,,, 0)
    oPrint:SayAlign(nLinha, 447, 'Liq.'                   , oFont10B ,  23  ,,, 0)
    oPrint:SayAlign(nLinha, 472, 'Bruto'                  , oFont10B ,  23  ,,, 0)
    oPrint:SayAlign(nLinha, 497, 'Total'                  , oFont10B ,  23  ,,, 0)
    oPrint:SayAlign(nLinha, 552, 'PCP'                    , oFont10B ,  30  ,,, 0)
    nLinha += 10
    oPrint:SayAlign(nLinha, 37 , 'Cliente'                , oFont10B ,  33  ,,, 0)
    oPrint:SayAlign(nLinha, 267, 'Fatu.'                  , oFont10B ,  23  ,,, 0)
    nLinha += 15

    //? Impressão das Observações do Pedido ao final do relatório
    oPrint:Box(780,15,800,580,'-6')
    oPrint:SayAlign(785, 25, 'Observações:' , oFont12B ,  70 ,,, 0)
    oPrint:SayAlign(785, 110, Alltrim((cAlias)->(C5_ZZOBPED)), oFont12,  505,,, 0)

Return nLinAntes

Static Function QbraRetLinha(cString, nQtdCar, nCol, oFont)

    Local cTxtLinha  := ''
    Local nQtdLinhas := MlCount(cString, nQtdCar,,.T.)
    Local nI         := 0

    if nQtdLinhas > 1
        for nI := 1 TO nQtdLinhas
            cTxtLinha := MemoLine(cString, nQtdCar, nI,,.T.)

            oPrint:Say(nLinha, nCol, cTxtLinha, oFont,,PRETO)
            nLinha += 10
        next
        nLinha -= (nQtdLinhas * 10)
    else
        oPrint:Say(nLinha, nCol, cString, oFont,,PRETO)
    endif

Return nQtdLinhas

//? HORIZONTAL - PAISAGEM

Static Function SetItensPaisg(cAlias,cAlias2)

    //? Imprime os Dados de Itens do Relatório no modelo Paisagem
    Local nQtdLinhas  := 0
    Local nQtdMaior   := 1
    Local cString     := ''
    Local nCont       := 1
    Private nCor      := PRETO

    //? Imprime Cabeçalho dos Itens 
    nLinAntes := CabecPsgItens(cAlias)

    (cAlias2)->(DbGoTop())

    //? Imprime os Dados dos Itens
    while (cAlias2)->(!EOF())
        if Alltrim((cAlias)->(C5_NUM)) == Alltrim((cAlias2)->(C6_NUM))
            QuebraPagina(nLinAntes, cAlias, cAlias2)
            oPrint:SayAlign(nLinha  , 17 , Alltrim((cAlias2)->(C6_ITEMPC)), oFont10, 33 ,,, 0)

            cString    := Alltrim((cAlias2)->(C6_ZZPRCLI))
            nQtdLinhas := QbraPsgLinha(cString,8,52,oFont10,0,43)
            nQtdMaior  := VerMaiorLinha(nQtdMaior,nQtdLinhas) 

            cString    := Alltrim((cAlias2)->(C6_PRODUTO))
            nQtdLinhas := QbraPsgLinha(cString,10,97,oFont10,0,58)
            nQtdMaior  := VerMaiorLinha(nQtdMaior,nQtdLinhas) 

            cString    := Alltrim((cAlias2)->(C6_DESCRI))
            nQtdLinhas := QbraPsgLinha(cString,20,147,oFont10,0,98)
            nQtdMaior  := VerMaiorLinha(nQtdMaior,nQtdLinhas) 

            cString    := CValToChar((cAlias2)->(C6_QTDVEN)) 
            nQtdLinhas := QbraPsgLinha(cString,8,245,oFont10,2,30)
            nQtdMaior  := VerMaiorLinha(nQtdMaior,nQtdLinhas) 

            cString    := Alltrim((cAlias2)->(C6_ZZDESEN)) 
            nQtdLinhas := QbraPsgLinha(cString,10,277,oFont10,0,48)
            nQtdMaior  := VerMaiorLinha(nQtdMaior,nQtdLinhas) 

            oPrint:SayAlign(nLinha  , 327, Alltrim((cAlias2)->(C6_ZZESPEC)), oFont10 ,  58  ,,, 0)

            cString    := CValToChar((cAlias2)->(RELACAOQTD)) 
            nQtdLinhas := QbraPsgLinha(cString,7,387,oFont10,0,33)
            nQtdMaior  := VerMaiorLinha(nQtdMaior,nQtdLinhas) 

            cString    := CValToChar((cAlias2)->(C6_ZZQTEMB)) 
            nQtdLinhas := QbraPsgLinha(cString,7,422,oFont10,0,33)
            nQtdMaior  := VerMaiorLinha(nQtdMaior,nQtdLinhas) 

            cString    := Alltrim((cAlias2)->(C6_ZZTPEMB))
            nQtdLinhas := QbraPsgLinha(cString,7,457,oFont10,0,38)
            nQtdMaior  := VerMaiorLinha(nQtdMaior,nQtdLinhas) 

            cString    := Alltrim((cAlias2)->(C6_ZZMEDID))
            nQtdLinhas := QbraPsgLinha(cString,12,497,oFont10,0,53)
            nQtdMaior  := VerMaiorLinha(nQtdMaior,nQtdLinhas) 

            cString    := Alltrim((cAlias2)->(C6_ZZLOTE))
            nQtdLinhas := QbraPsgLinha(cString,10,552,oFont10,0,53)
            nQtdMaior  := VerMaiorLinha(nQtdMaior,nQtdLinhas) 

            oPrint:SayAlign(nLinha  , 607, Alltrim((cAlias2)->(C6_ZZRELAT))   , oFont10 ,  48  ,,, 0)

            cString    := CValToChar((cAlias2)->(C6_ZZPELIQ))
            nQtdLinhas := QbraPsgLinha(cString,6,657,oFont10,0,28)
            nQtdMaior  := VerMaiorLinha(nQtdMaior,nQtdLinhas) 

            cString    := CValToChar((cAlias2)->(C6_ZZPEBRU))
            nQtdLinhas := QbraPsgLinha(cString,6,687,oFont10,0,28)
            nQtdMaior  := VerMaiorLinha(nQtdMaior,nQtdLinhas) 

            cString    := CValToChar((cAlias2)->(C6_ZZPETOT))
            nQtdLinhas := QbraPsgLinha(cString,6,717,oFont10,0,28)
            nQtdMaior  := VerMaiorLinha(nQtdMaior,nQtdLinhas) 

            oPrint:SayAlign(nLinha  , 747, CValToChar((cAlias2)->(C6_NOTA))   , oFont10 ,  28  ,,, 0)
            oPrint:SayAlign(nLinha  , 777, CValToChar((cAlias2)->(C6_ZZOBSEV)), oFont10 ,  48  ,,, 0)
            nLinha += nQtdMaior * 10
            oPrint:Line(nLinha, 15  , nLinha ,825  ,,'-6')
        endif
        (cAlias2)->(DbSkip())
    enddo
    (cAlias2)->(DbGoTop())

    if lQuebPag
        nLinAntes := 145
    endif

    //? Imprime as Linhas Verticais
    for nCont := 1 TO 19
        oPrint:Line(nLinAntes, aColPaisagem[nCont], nLinha, aColPaisagem[nCont], , '-6')
    next
    oPrint:Line(nLinha, 15, nLinha ,825,,'-6')

    nLinha += 10

Return

Static Function CabecPsgItens(cAlias)

    Local nLinAntes

    oPrint:Box(nLinha,15  ,nLinha+24,825,'-6')
    nLinAntes := nLinha
    oPrint:SayAlign(nLinha  , 17 , 'Item'                   , oFont10B ,  33  ,,, 0)
    oPrint:SayAlign(nLinha  , 52 , 'Cod. Prd.'              , oFont10B ,  43  ,,, 0)
    oPrint:SayAlign(nLinha+5, 97 , 'Produto'                , oFont10B ,  58  ,,, 0)
    oPrint:SayAlign(nLinha+5, 147, 'Descrição'              , oFont10B ,  98  ,,, 0)
    oPrint:SayAlign(nLinha+5, 245, 'Qtd.'                   , oFont10B ,  30  ,,, 2)
    oPrint:SayAlign(nLinha+5, 277, 'Desenho'                , oFont10B ,  48  ,,, 0)
    oPrint:SayAlign(nLinha+5, 327, 'Especificação'          , oFont10B ,  58  ,,, 0)
    oPrint:SayAlign(nLinha  , 387, 'Qtd. Pç'                , oFont10B ,  33  ,,, 0)
    oPrint:SayAlign(nLinha  , 422, 'Qtd.'                   , oFont10B ,  33  ,,, 0)
    oPrint:SayAlign(nLinha  , 457, 'Tipo'                   , oFont10B ,  38  ,,, 0)
    oPrint:SayAlign(nLinha  , 497, 'Medidas'                , oFont10B ,  53  ,,, 0)
    oPrint:SayAlign(nLinha+5, 552, 'Lote'                   , oFont10B ,  53  ,,, 0)
    oPrint:SayAlign(nLinha  , 607, 'Relatório'              , oFont10B ,  48  ,,, 0)
    oPrint:SayAlign(nLinha  , 657, 'Peso'                   , oFont10B ,  28  ,,, 0)
    oPrint:SayAlign(nLinha  , 687, 'Peso'                   , oFont10B ,  28  ,,, 0)
    oPrint:SayAlign(nLinha  , 717, 'Peso'                   , oFont10B ,  28  ,,, 0)
    oPrint:SayAlign(nLinha+5, 747, 'N° NF'                  , oFont10B ,  28  ,,, 0)
    oPrint:SayAlign(nLinha+5, 777, 'Obs. PCP'               , oFont10B ,  48  ,,, 0)
    nLinha += 10 
    oPrint:SayAlign(nLinha, 17 , 'Cliente'                  , oFont10B ,  35  ,,, 0)
    oPrint:SayAlign(nLinha, 52 , 'Cliente'                  , oFont10B ,  45  ,,, 0)
    oPrint:SayAlign(nLinha, 387, 'Faturar'                  , oFont10B ,  35  ,,, 0)
    oPrint:SayAlign(nLinha, 422, 'Emb.'                     , oFont10B ,  35  ,,, 0)
    oPrint:SayAlign(nLinha, 457, 'Emb.'                     , oFont10B , 40  ,,, 0)
    oPrint:SayAlign(nLinha, 497, '(AxLxC)'                  , oFont10B ,  55  ,,, 0)
    oPrint:SayAlign(nLinha, 607, 'CQ'                       , oFont10B ,  50  ,,, 0)
    oPrint:SayAlign(nLinha, 657, 'Liq.'                     , oFont10B ,  30  ,,, 0)
    oPrint:SayAlign(nLinha, 687, 'Bruto'                    , oFont10B ,  30  ,,, 0)
    oPrint:SayAlign(nLinha, 717, 'Total'                    , oFont10B ,  30  ,,, 0)
    nLinha += 15

    //? Impressão das Observações do Pedido ao final do relatório
    oPrint:Box(555, 15, 580, 825,'-6')
    oPrint:SayAlign(560, 25, 'Observações:', oFont12B, 70, , , 0)
    oPrint:SayAlign(560, 110, Alltrim((cAlias)->(C5_ZZOBPED)), oFont12,  505, , , 0)

Return nLinAntes

Static Function QbraPsgLinha(cString, nQtdCar, nCol, oFont, nPosicao, nTam)

    Local cTxtLinha  := ''
    Local nQtdLinhas := MlCount(cString, nQtdCar, , .T.)
    Local nI         := 0

    if nQtdLinhas > 1
        for nI := 1 TO nQtdLinhas
            cTxtLinha := MemoLine(cString, nQtdCar, nI,,.T.)
            oPrint:SayAlign(nLinha, nCol, cTxtLinha, oFont,  nTam, , , nPosicao)
            nLinha += 10
        next
        nLinha -= (nQtdLinhas * 10)
    else
        oPrint:SayAlign(nLinha, nCol, cString, oFont,  nTam, , , nPosicao)
    endif

Return nQtdLinhas

//? Funções Auxiliares

Static Function VerMaiorLinha(nMaior,nQtd)

    Local nResultado

    if nQtd > nMaior
        nResultado := nQtd
    else
        nResultado := nMaior
    endif

Return nResultado

Static Function QuebraPagina(nLinAntes,cAlias,cAlias2)

    Local nCont := 1

    if oPrint:GetOrientation() == 1
        if nLinha > (700)
            oPrint:EndPage()
            for nCont := 1 TO 19
                oPrint:Line(nLinAntes, aColRetrato[nCont], nLinha, aColRetrato[nCont], ,'-6')
            next
            oPrint:StartPage()
            nLinha := 145
            SetInfoRelat(cAlias)
            CabecRetItens(cAlias)
            nLinha += 10
            lQuebPag := .T.
        endif
    else
        if nLinha > (520)
            oPrint:EndPage()
            for nCont := 1 TO 19
                oPrint:Line(nLinAntes, aColPaisagem[nCont], nLinha, aColPaisagem[nCont], ,'-6')
            next
            oPrint:StartPage()
            nLinha := 145
            SetInfoRelat(cAlias)
            CabecPsgItens(cAlias)
            lQuebPag := .T.
        endif
    endif

Return
