#INCLUDE 'TOTVS.CH'

/*/{Protheus.doc} User Function ValEntPrd
    6. Exercício | Rotina: Validação preenchimento de lote na entrada de produtos
    @type  Function
    @author André Lucas
    @since 31/08/2023
    @version 0.1
    @see https://tdn.totvs.com/pages/releaseview.action?pageId=6085513
/*/

User Function ValEntPrd()

	Local lRet		:= .T.
	Local cProd		:= ""
	Local cRastro	:= ""
	Local nInicio	:= 0
	Local nFim		:= 0
	Local nX		:= 0

	if IsInCallStack("U_MT100TOK") .OR. IsInCallStack("U_MT140TOK")
		nInicio := 1
		nFim := len(aCols)
	else
		nInicio := n
		nFim := n
	endif

	for nX := nInicio to nFim

		if lRet .and. !aCols[nX,LEN(aCols[nX])] 

			cProd 	:= aCols[nX,GdFieldPos("D1_COD")]
			cRastro	:= Posicione("SB1",1,xFilial("SB1")+cProd,"B1_RASTRO")

			if cRastro <> "N"
				if Empty(aCols[nX,GdFieldPos("D1_LOTEFOR")]) .OR. Empty(aCols[nX,GdFieldPos("D1_DTVALID")])
					FWAlertInfo("O produto '"+ Alltrim(cProd) +"' linha '" + cvaltochar(nX) + "'  possui controle de lote ativado e o 'Lote Fornecedor' e 'Valid.Lote' do mesmo não foi preenchido. " + CRLF + CRLF + " Por favor, verifique.", "INFORME")
					lRet := .F.
				endif
			endif
			
		endif
		
	next nX

Return (lRet)
