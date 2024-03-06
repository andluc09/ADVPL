#INCLUDE 'TOTVS.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'REPORT.CH'

#DEFINE PRETO RGB(000, 000, 000)

/*/{Protheus.doc} User Function RelPdVnd
    Exercício | Relatório de Pedido de Venda 
    @type  Function
    @author André Lucas M. Santos
    @since 05/12/2023
    @version 0.1
    @see https://tdn.totvs.com/display/public/framework/TReport
/*/

User Function RelPdVnd(lBotao)

    Local aArea     := GetArea()
    Local aAreaSC5  := SC5->(GetArea())
    Local aAreaSC6  := SC6->(GetArea())
    Local aAreaSA1  := SA1->(GetArea())
    Default lBotao  := .F.
    Private oReport := NIL
    Private nOpcao

    FWalertInfo(cValToChar(lBotao), 'Conteúdo')

    oReport := GeraReport(lBotao)

    TelOpcoes(lBotao)

    RestArea(aAreaSA1)
    RestArea(aAreaSC6)
    RestArea(aAreaSC5)
    RestArea(aArea)

Return 

Static Function TelOpcoes(lBotao)

    Local oDlg

    DEFINE MSDIALOG oDlg TITLE 'Pedido de Vendas' FROM 000,000 TO 100,330 PIXEL
    @ 010,010 SAY 'Relatório de Pedido de Vendas' SIZE 100,20 OF oDlg PIXEL
    @ 030,010 BUTTON 'Configurar'                 SIZE 030,015 OF oDlg ACTION (oReport := GeraReport(lBotao)) PIXEL 
    @ 030,050 BUTTON 'Imprimir'                   SIZE 030,015 OF oDlg ACTION (nOpcao := 1, oReport:PrintDialog(),oDlg:End()) PIXEL 
    @ 030,090 BUTTON 'Visualizar'                 SIZE 030,015 OF oDlg ACTION (nOpcao := 2, oReport:PrintDialog()) PIXEL 
    @ 030,130 BUTTON 'Sair'                       SIZE 030,015 OF oDlg ACTION (nOpcao := 3, oDlg:End()) PIXEL 

    ACTIVATE MSDIALOG oDlg CENTERED

Return nOpcao

Static Function GeraReport(lBotao)

    Local cAlias    := GetNextAlias()
    Local oRel      := NIL
    Local oSectPar  := NIL
    Local oSection0 := NIL 
    Local oSection1 := NIL 
    Local oSection2 := NIL 

    SX1Pergunt(lBotao)

    oRel:= TReport():New('TREPORT', 'ANÁLISE CRITICA 2', /**/, {|oRel| Imprime(oRel, cAlias, lBotao)}, 'Esse relatório imprimirá as informações dos Pedidos de Venda selecionados.', .F.)

    oRel:SetLogo("\system\LGMID.png") 

    oSectPar  := TRSection():New(oRel,'Parâmetros', /*Table*/, /*Order*/)

    TRCell():New(oSectPar, 'XX_EMPRESA', '', 'ASW BRASIL TECNOLOGIA EM PLÁSTICOS LTDA', /*Picture*/, 030, /*lPixel*/,/*{|| code-block de impressao }*/,'CENTER',/*lLineBreak*/,'CENTER',/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)

    oSectPar01  := TRSection():New(oSectPar,'Parâmetros', /*Table*/, /*Order*/)

    TRCell():New(oSectPar01, 'XX_ENDFISC', '', 'RUA ADEMAR BOMBO, 380, PQ. INDUSTRIAL, MOGI GUAÇU/SP 13849-224' , /*Picture*/, 030, /*lPixel*/,/*{|| code-block de impressao }*/,'CENTER',/*lLineBreak*/,'CENTER',/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)

    oSectPar02  := TRSection():New(oSectPar01,'Parâmetros', /*Table*/, /*Order*/)

    TRCell():New(oSectPar02, 'XX_MAILINS', '', 'E-mail: vendas@asw.com.br; comercial@aswbrasil.com.br' , /*Picture*/, 030, /*lPixel*/,/*{|| code-block de impressao }*/,'CENTER',/*lLineBreak*/,'CENTER',/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)

    oSectPar03  := TRSection():New(oSectPar02,'Parâmetros', /*Table*/, /*Order*/)

    TRCell():New(oSectPar03, 'XX_FONEINS', '', 'Fone: (19) 3851-3100' , /*Picture*/, 030, /*lPixel*/,/*{|| code-block de impressao }*/,'CENTER',/*lLineBreak*/,'CENTER',/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)

    oSectPar04  := TRSection():New(oSectPar03,'Parâmetros', /*Table*/, /*Order*/)

    TRCell():New(oSectPar04, 'XX_CNPJEMP', '', 'CNPJ: 09.662.563/0001-10 IE: 455.183.546.113' , /*Picture*/, 030, /*lPixel*/,/*{|| code-block de impressao }*/,'CENTER',/*lLineBreak*/,'CENTER',/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)

    oSection0 := TRSection():New(oRel, 'Cadastro de Pedido de Venda', /*Table*/, /*Order*/)

    TRCell():New(oSection0, 'C5_NUM', 'SC5', 'Pedido Nº', /*Picture*/, 10, /*Pixel*/, /*Bloco de Código*/, 'CENTER', .F., 'CENTER', /*Compat.*/, /*ColSpace*/, .T., /*Cor Fundo*/, PRETO, .T.)
    TRCell():New(oSection0, 'C5_EMISSAO', 'SC5', 'Data', /*Picture*/, 15, /*Pixel*/, /*Bloco de Código*/, 'LEFT', .T., 'LEFT', /*Compat.*/, /*ColSpace*/, .T., /*Cor Fundo*/, PRETO, .T.)

    oSection1 := TRSection():New(oSection0, 'Informações do Pedido de Venda', /*Table*/, /*Order*/)  

    TRCell():New(oSection1, "(A1_COD + ' - ' + A1_LOJA + ' - ' + A1_NOME) AS 'CLIENTE'", 'SA1', 'Cliente', /*Picture*/, 25, /*Pixel*/, /*Bloco de Código*/, 'CENTER', .F., 'CENTER', /*Compat.*/, /*ColSpace*/, .T., /*Cor Fundo*/, PRETO, .T.)
    TRCell():New(oSection1, 'A1_CGC', 'SA1', 'CNPJ', /*Picture*/, 20, /*Pixel*/, /*Bloco de Código*/, 'LEFT', .T., 'LEFT', /*Compat.*/, /*ColSpace*/, .T., /*Cor Fundo*/, PRETO, .T.)
    TRCell():New(oSection1, 'C5_ZZPDCLI', 'SC5', 'Nº Pedido Cliente', /*Picture*/, 9, /*Pixel*/, /*Bloco de Código*/, 'CENTER', .F., 'CENTER', /*Compat.*/, /*ColSpace*/, .T., /*Cor Fundo*/, PRETO, .T.)
    TRCell():New(oSection1, 'C5_ZZDTEMB', 'SC5', 'Dt. Embarque', /*Picture*/, 15, /*Pixel*/, /*Bloco de Código*/, 'CENTER', .T., 'CENTER', /*Compat.*/, /*ColSpace*/, .T., /*Cor Fundo*/, PRETO, .T.)
    TRCell():New(oSection1, 'C5_FECENT', 'SC5', 'Dt. Entrega', /*Picture*/, 15, /*Pixel*/, /*Bloco de Código*/, 'CENTER', .F., 'CENTER', /*Compat.*/, /*ColSpace*/, .T., /*Cor Fundo*/, PRETO, .T.)
    TRCell():New(oSection1, 'C5_ZZNCONT', 'SC5', 'Nº Contrato', /*Picture*/, 20, /*Pixel*/, /*Bloco de Código*/, 'CENTER', .T., 'CENTER', /*Compat.*/, /*ColSpace*/, .T., /*Cor Fundo*/, PRETO, .T.)

    oSection2 := TRSection():New(oSection1, 'Itens do Pedido de Venda', /*Table*/, /*Order*/)

    TRCell():New(oSection2, 'C6_ITEMPC', 'SC6', 'Item Cliente', /*Picture*/, 5, /*Pixel*/, /*Bloco de Código*/, 'CENTER', .F., 'CENTER', /*Compat.*/, /*ColSpace*/, .T., /*Cor Fundo*/, PRETO, .T.)
    TRCell():New(oSection2, 'C6_ZZPRCLI', 'SC6', 'Cod. Prd. Cliente', /*Picture*/, 12, /*Pixel*/, /*Bloco de Código*/, 'CENTER', .F., 'CENTER', /*Compat.*/, /*ColSpace*/, .T., /*Cor Fundo*/, PRETO, .T.)
    TRCell():New(oSection2, 'C6_PRODUTO', 'SC6', 'Produto', /*Picture*/, 12, /*Pixel*/, /*Bloco de Código*/, 'LEFT', .T., 'LEFT', /*Compat.*/, /*ColSpace*/, .T., /*Cor Fundo*/, PRETO, .T.)
    TRCell():New(oSection2, 'C6_DESCRI', 'SC6', 'Descrição', /*Picture*/, 35, /*Pixel*/, /*Bloco de Código*/, 'CENTER', .F., 'CENTER', /*Compat.*/, /*ColSpace*/, .T., /*Cor Fundo*/, PRETO, .T.)
    TRCell():New(oSection2, 'C6_QTDVEN', 'SC6', 'Qtd.', /*Picture*/, 5, /*Pixel*/, /*Bloco de Código*/, 'CENTER', .F., 'CENTER', /*Compat.*/, /*ColSpace*/, .T., /*Cor Fundo*/, PRETO, .T.)
    TRCell():New(oSection2, 'C6_ZZDESEN', 'SC6', 'Desenho', /*Picture*/, 20, /*Pixel*/, /*Bloco de Código*/, 'CENTER', .F., 'CENTER', /*Compat.*/, /*ColSpace*/, .T., /*Cor Fundo*/, PRETO, .T.)
    TRCell():New(oSection2, 'C6_ZZESPEC', 'SC6', 'Especificação', /*Picture*/, 15, /*Pixel*/, /*Bloco de Código*/, 'CENTER', .F., 'CENTER', /*Compat.*/, /*ColSpace*/, .T., /*Cor Fundo*/, PRETO, .T.)
    TRCell():New(oSection2, "CAST((C6_QTDVEN - C6_QTDENT) AS VARCHAR) AS 'QTDPCFATUR'", 'SC6', 'Qtd. Pç Faturar', /*Picture*/, 6, /*Pixel*/, /*Bloco de Código*/, 'CENTER', .F., 'CENTER', /*Compat.*/, /*ColSpace*/, .T., /*Cor Fundo*/, PRETO, .T.)
    TRCell():New(oSection2, 'C6_ZZQTEMB', 'SC6', 'Qtd. Emb.', /*Picture*/, 6, /*Pixel*/, /*Bloco de Código*/, 'LEFT', .T., 'LEFT', /*Compat.*/, /*ColSpace*/, .T., /*Cor Fundo*/, PRETO, .T.)
    TRCell():New(oSection2, 'C6_ZZTPEMB', 'SC6', 'Tipo Emb.', /*Picture*/, 12, /*Pixel*/, /*Bloco de Código*/, 'CENTER', .F., 'CENTER', /*Compat.*/, /*ColSpace*/, .T., /*Cor Fundo*/, PRETO, .T.)
    TRCell():New(oSection2, 'C6_ZZMEDID', 'SC6', 'Medidas (AxLxC)', /*Picture*/, 20, /*Pixel*/, /*Bloco de Código*/, 'CENTER', .F., 'CENTER', /*Compat.*/, /*ColSpace*/, .T., /*Cor Fundo*/, PRETO, .T.)
    TRCell():New(oSection2, 'C6_ZZLOTE', 'SC6', 'Lote', /*Picture*/, 10, /*Pixel*/, /*Bloco de Código*/, 'CENTER', .F., 'CENTER', /*Compat.*/, /*ColSpace*/, .T., /*Cor Fundo*/, PRETO, .T.)
    TRCell():New(oSection2, 'C6_ZZRELAT', 'SC6', 'Relatório CQ', /*Picture*/, 9, /*Pixel*/, /*Bloco de Código*/, 'CENTER', .F., 'CENTER', /*Compat.*/, /*ColSpace*/, .T., /*Cor Fundo*/, PRETO, .T.)
    TRCell():New(oSection2, 'C6_ZZPELIQ', 'SC6', 'Peso Líq.', /*Picture*/, 6, /*Pixel*/, /*Bloco de Código*/, 'CENTER', .F., 'CENTER', /*Compat.*/, /*ColSpace*/, .T., /*Cor Fundo*/, PRETO, .T.)
    TRCell():New(oSection2, 'C6_ZZPEBRU', 'SC6', 'Peso Bruto', /*Picture*/, 6, /*Pixel*/, /*Bloco de Código*/, 'LEFT', .T., 'LEFT', /*Compat.*/, /*ColSpace*/, .T., /*Cor Fundo*/, PRETO, .T.)
    TRCell():New(oSection2, 'C6_ZZPETOT', 'SC6', 'Peso Total', /*Picture*/, 9, /*Pixel*/, /*Bloco de Código*/, 'CENTER', .F., 'CENTER', /*Compat.*/, /*ColSpace*/, .T., /*Cor Fundo*/, PRETO, .T.)
    TRCell():New(oSection2, 'C6_NOTA', 'SC6', 'Nº NF', /*Picture*/, 12, /*Pixel*/, /*Bloco de Código*/, 'CENTER', .F., 'CENTER', /*Compat.*/, /*ColSpace*/, .T., /*Cor Fundo*/, PRETO, .T.)
    TRCell():New(oSection2, 'C6_ZZOBSEV', 'SC6', 'Obs. PCP', /*Picture*/, 15, /*Pixel*/, /*Bloco de Código*/, 'CENTER', .F., 'CENTER', /*Compat.*/, /*ColSpace*/, .T., /*Cor Fundo*/, PRETO, .T.)

    oBreak := TRBreak():New(oSection0, oSection0:Cell('C5_NUM'), , .T.)

Return oRel

Static Function Imprime(oRel, cAlias, lBotao)

    Local oSectPar   := oRel:Section(1)
    Local oSectPar01 := oSectPar:Section(1)
    Local oSectPar02 := oSectPar01:Section(1)
    Local oSectPar03 := oSectPar02:Section(1)
    Local oSectPar04 := oSectPar03:Section(1)
    Local oSection0  := oRel:Section(2)
    Local oSection1  := oSection0:Section(1)
    Local oSection2  := oSection1:Section(1)
    Local nTotReg    := 0
    Local cQuery     := GeraQuery(lBotao)
    Local cPedFinal  := ''
    Local cText      := 'Observações: '

    oSectPar:Init()
    //oSectPar:Cell('XX_EMPRESA'):SetValue('ASW BRASIL TECNOLOGIA EM PLÁSTICOS LTDA')
    oSectPar:Cell('XX_EMPRESA'):SetValue()
    oSectPar:PrintLine()
    oSectPar:Finish()
    oSectPar01:Init()
    //oSectPar01:Cell('XX_ENDFISC'):SetValue('RUA ADEMAR BOMBO, 380, PQ. INDUSTRIAL, MOGI GUAÇU/SP 13849-224')
    oSectPar01:Cell('XX_ENDFISC'):SetValue()
    oSectPar01:PrintLine()
    oSectPar01:Finish()
    oSectPar02:Init()
    //oSectPar02:Cell('XX_MAILINS'):SetValue('E-mail: vendas@asw.com.br; comercial@aswbrasil.com.br')
    oSectPar02:Cell('XX_MAILINS'):SetValue()
    oSectPar02:PrintLine()
    oSectPar02:Finish()
    oSectPar03:Init()
    //oSectPar03:Cell('XX_FONEINS'):SetValue('Fone: (19) 3851-3100')
    oSectPar03:Cell('XX_FONEINS'):SetValue()
    oSectPar03:PrintLine()
    oSectPar03:Finish()
    oSectPar04:Init()
    //oSectPar04:Cell('XX_CNPJEMP'):SetValue('CNPJ: 09.662.563/0001-10 IE: 455.183.546.113')
    oSectPar04:Cell('XX_CNPJEMP'):SetValue()
    oSectPar04:PrintLine()
    oSectPar04:Finish()

    DBUseArea(.T., 'TOPCONN', TCGenQry(/*Compat*/, /*Compat*/, cQuery), cAlias, .T., .T.)

    cText += AllTrim((cAlias)->(C5_ZZOBPED))

    Count TO nTotReg

    oRel:SetMeter(nTotReg)

    oRel:SetTitle('ANÁLISE CRITICA 2')

    oRel:StartPage()

    (cAlias)->(DBGoTop())

    while (cAlias)->(!EOF())
        if oRel:Cancel()
            Exit
        endif

        if AllTrim(cPedFinal) <> AllTrim((cAlias)->(C5_NUM))

            if !Empty(cPedFinal)
                oSection2:Finish() 
                oSection1:Finish() 
                oSection0:Finish() 
                oRel:SetPageFooter( 2, {| | oRel:PrintText(cText) }, .F.)
                oRel:EndPage(.F.) 
			endif

            oSection0:Init()

            oSection0:Cell('C5_NUM'):SetValue((cAlias)->(C5_NUM))
            oSection0:Cell('C5_EMISSAO'):SetValue(DToC(StoD((cAlias)->(C5_EMISSAO))))

            oSection0:PrintLine()

            oSection1:Init()

            oSection1:Cell('CLIENTE'):SetValue((cAlias)->(CLIENTE))
            oSection1:Cell('A1_CGC'):SetValue((cAlias)->(A1_CGC))
            oSection1:Cell('C5_ZZPDCLI'):SetValue((cAlias)->(C5_ZZPDCLI))
            oSection1:Cell('C5_ZZDTEMB'):SetValue(DToC(StoD((cAlias)->(C5_ZZDTEMB))))
            oSection1:Cell('C5_FECENT'):SetValue(DToC(StoD((cAlias)->(C5_FECENT))))
            oSection1:Cell('C5_ZZNCONT'):SetValue((cAlias)->(C5_ZZNCONT))

            cPedFinal := ((cAlias)->(C5_NUM))

            oSection1:PrintLine()

        endif

        oSection2:Init()

        oSection2:Cell('C6_ITEMPC'):SetValue(AllTrim((cAlias)->(C6_ITEMPC))) 
        oSection2:Cell('C6_ZZPRCLI'):SetValue(AllTrim((cAlias)->(C6_ZZPRCLI))) 
        oSection2:Cell('C6_PRODUTO'):SetValue(AllTrim((cAlias)->(C6_PRODUTO))) 
        oSection2:Cell('C6_DESCRI'):SetValue(AllTrim((cAlias)->(C6_DESCRI))) 
        oSection2:Cell('C6_QTDVEN'):SetValue(AllTrim(cValToChar((cAlias)->(C6_QTDVEN)))) 
        oSection2:Cell('C6_ZZDESEN'):SetValue(AllTrim((cAlias)->(C6_ZZDESEN))) 
        oSection2:Cell('C6_ZZESPEC'):SetValue(AllTrim((cAlias)->(C6_ZZESPEC))) 
        oSection2:Cell("CAST((C6_QTDVEN - C6_QTDENT) AS VARCHAR) AS 'QTDPCFATUR'"):SetValue(AllTrim((cAlias)->(QTDPCFATUR))) 
        oSection2:Cell('C6_ZZQTEMB'):SetValue(AllTrim(cValToChar((cAlias)->(C6_ZZQTEMB)))) 
        oSection2:Cell('C6_ZZTPEMB'):SetValue(AllTrim((cAlias)->(C6_ZZTPEMB))) 
        oSection2:Cell('C6_ZZMEDID'):SetValue(AllTrim((cAlias)->(C6_ZZMEDID))) 
        oSection2:Cell('C6_ZZLOTE'):SetValue(AllTrim((cAlias)->(C6_ZZLOTE))) 
        oSection2:Cell('C6_ZZRELAT'):SetValue(AllTrim((cAlias)->(C6_ZZRELAT))) 
        oSection2:Cell('C6_ZZPELIQ'):SetValue(AllTrim(cValToChar((cAlias)->(C6_ZZPELIQ)))) 
        oSection2:Cell('C6_ZZPEBRU'):SetValue(AllTrim(cValToChar((cAlias)->(C6_ZZPEBRU)))) 
        oSection2:Cell('C6_ZZPETOT'):SetValue(AllTrim(cValToChar((cAlias)->(C6_ZZPETOT)))) 
        oSection2:Cell('C6_NOTA'):SetValue(AllTrim((cAlias)->(C6_NOTA))) 
        oSection2:Cell('C6_ZZOBSEV'):SetValue(AllTrim((cAlias)->(C6_ZZOBSEV))) 

        oSection2:PrintLine()

        oRel:SkipLine(1)

        oRel:ThinLine()

        oRel:SetPageFooter( 2, {| | oRel:PrintText(cText) }, .F.)

        oRel:IncMeter()

        (cAlias)->(DBSkip())

    enddo

    (cAlias)->(DBCloseArea())

    oSection2:Finish()
    oSection1:Finish()
    oSection0:Finish() 

    oRel:SkipLine(1)

    oRel:EndPage()

Return

Static Function GeraQuery(lBotao)

    Local cQuery     := ''
    Local cNumPedIni := IIF(lBotao, SC5->C5_NUM, MV_PAR01)
    Local cNumPedFim := IIF(lBotao, SC5->C5_NUM, MV_PAR02)
    Local cDtEmisIni := IIF(lBotao, SC5->C5_EMISSAO, MV_PAR03)
    Local cDtEmisFim := IIF(lBotao, SC5->C5_EMISSAO, MV_PAR04)

    cQuery := " SELECT C5_NUM, C5_EMISSAO, C5_ZZPDCLI, C5_ZZDTEMB, C5_FECENT, C5_ZZNCONT, C5_ZZOBPED,  " + CRLF
    cQuery += " C6_ITEMPC, C6_ZZPRCLI, C6_PRODUTO, C6_DESCRI, C6_QTDVEN, C6_ZZDESEN, C6_ZZESPEC, CAST((C6_QTDVEN - C6_QTDENT) AS VARCHAR) AS 'QTDPCFATUR', C6_ZZQTEMB, C6_ZZTPEMB, C6_ZZMEDID, C6_ZZLOTE, C6_ZZRELAT, C6_ZZPELIQ, C6_ZZPEBRU, C6_ZZPETOT, C6_NOTA, C6_ZZOBSEV, " + CRLF
    cQuery += " (A1_COD + ' - ' + A1_LOJA + ' - ' + A1_NOME) AS 'CLIENTE', A1_CGC " + CRLF
    cQuery += " FROM " + RETSQLNAME('SC5') + " AS SC5 " + CRLF 
    cQuery += " INNER JOIN  " + RETSQLNAME('SC6') + " AS SC6 ON SC6.C6_FILIAL = '" + FwFilial("SC6") + "' AND SC6.C6_NUM = SC5.C5_NUM AND SC6.D_E_L_E_T_ = '' " + CRLF    
    cQuery += " INNER JOIN  " + RETSQLNAME('SA1') + " AS SA1 ON SA1.A1_FILIAL = '" + FwFilial("SA1") + "' AND SA1.A1_COD = SC5.C5_CLIENTE AND SA1.A1_LOJA = SC5.C5_LOJACLI AND SA1.D_E_L_E_T_ = '' " + CRLF    
    cQuery += " WHERE SC5.C5_NUM BETWEEN '" + cNumPedIni + "' AND '" + cNumPedFim + "' AND " + CRLF   
    cQuery += " SC5.C5_EMISSAO BETWEEN '" + DTOS(cDtEmisIni) + "' AND '" + DTOS(cDtEmisFim) + "' AND " + CRLF 
    cQuery += " SC5.C5_FILIAL = '" + FwFilial("SC5") + "' AND " + CRLF 
    cQuery += " SC5.D_E_L_E_T_ = '' " + CRLF
    cQuery += " ORDER BY SC5.C5_EMISSAO, SC5.C5_NUM "

Return cQuery

Static Function SX1Pergunt(lBotao)

    Local lOk := .F.

    if Pergunte('ZZRELPDVND', !lBotao, 'Busca por Pedidos de Venda:')
        lOk := .T.
    endif

Return lOk
