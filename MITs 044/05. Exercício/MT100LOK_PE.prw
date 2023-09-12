#INCLUDE 'TOTVS.CH'

/*/{Protheus.doc} User Function MT100LOK
    5. Exerc�cio | Ponto de Entrada: MT100LOK
    @type  Function
    @author Andr� Lucas
    @since 29/08/2023
    @version 0.1
    @see https://tdn.totvs.com/pages/releaseview.action?pageId=6085397
/*/

User Function MT100LOK()

	Local lRet     := .T.
	Local cArmServ := GetNewPar("ZZ_ARMSRV","SE")
	Local nPosArm  := GdFieldPos('D1_LOCAL',aHeader)
	Local nPosTes  := GdFieldPos('D1_TES',aHeader)
	Local cTes     := ""
	Local cMsg     := ""

	If !(aCols[n][Len(aCols[n])])
		cTes := acols[n,nPosTes]
		if acols[n,nPosArm] $ cArmServ  
			if Posicione("SF4",1,xFilial("SF4")+cTes,"F4_ESTOQUE")=="S"
				lRet := .F.
				cMsg += "TES '"+cTES+"' movimenta estoque e o armaz�m informado n�o movimenta estoque. Favor verificar." + CRLF + CRLF
                FWAlertInfo(cMsg, "INFORME")
			endif
		else
			if Posicione("SF4",1,xFilial("SF4")+cTes,"F4_ESTOQUE")=="N"
				lRet := .F.
				cMsg += "TES '"+cTES+"' n�o movimenta estoque e o armaz�m informado movimenta estoque. Favor verificar." + CRLF + CRLF
                FWAlertInfo(cMsg, "INFORME")
			endif
		endif
	endif

Return(lRet)
