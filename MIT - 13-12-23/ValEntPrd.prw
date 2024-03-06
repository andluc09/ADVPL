#INCLUDE 'TOTVS.CH'

/*/{Protheus.doc} User Function ValEntPrd
    6. Exercício | Rotina: Validação preenchimento de lote na entrada de produtos
    @type  Function
    @author André Lucas
    @since 13/12/2023
    @version 0.1
	@see https://tdn.totvs.com/display/public/framework/FWIsInCallStack
    @see https://tdn.totvs.com/pages/releaseview.action?pageId=6085513
	@see https://tdn.totvs.com/pages/releaseview.action?pageId=6085400
	@see https://tdn.totvs.com/pages/releaseview.action?pageId=6085397
	@see https://tdn.totvs.com/pages/releaseview.action?pageId=6085509
/*/

User Function ValEntPrd()

	Local aArea	        := GetArea()
	Local aAreaSB1      := SB1->(GetArea())
	Local aAreaSD1      := SD1->(GetArea())
	Local lRet	        := .T.
	Local cProduto      := ""
	Local cRastro       := ""
	Local nInicioItemNF := 0
	Local nFimItemNF	:= 0
	Local nCont	        := 0

	if FWIsInCallStack("U_MT100TOK") .OR. FWIsInCallStack("U_MT140TOK") //? Identifica se já foi chamada a função —> lRet
		nInicioItemNF := 1
		nFimItemNF    := LEN(aCols)
	else
		nInicioItemNF := n //? N variável nativa numérica (Private), representa o número de produtos da NF (Nota Fiscal) 
		nFimItemNF    := n 
	endif

	for nCont := nInicioItemNF to nFimItemNF
		if lRet .AND. !GDDeleted(nCont, aHeader, aCols)
			cProduto := aCols[nCont,GDFieldPos("D1_COD")] //? GdFieldPos("campo") - Pega a posição do aCols —> nRet
			cRastro	 := Posicione("SB1",1,xFilial("SB1")+cProduto,"B1_RASTRO")

			if cRastro <> "N"
				if Empty(aCols[nCont,GDFieldPos("D1_LOTECTL")]) .OR. Empty(aCols[nCont,GDFieldPos("D1_DTVALID")])
					FWAlertInfo("O produto '"+ AllTrim(cProduto) +"' linha '" + cValToChar(nCont) + "'  possui controle de lote ativado e o 'Lote Fornecedor' e 'Valid.Lote' do mesmo não foi preenchido. " + CRLF + CRLF + " Por favor, verifique.", "INFORME")
					lRet := .F.
				endif
			endif
		endif
	next

	RestArea(aAreaSD1)
	RestArea(aAreaSB1)
	RestArea(aArea)

Return (lRet)
