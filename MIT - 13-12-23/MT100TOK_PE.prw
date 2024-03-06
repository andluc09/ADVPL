#INCLUDE 'TOTVS.CH'

/*/{Protheus.doc} User Function MT100TOK [TRANSACTION - TRANSA��O]
    6. Exerc�cio | Ponto de Entrada: MT100TOK - Valida a inclus�o de NF (Documento de Entrada)
    @type  Function
    @author Andr� Lucas
    @since 13/12/2023
    @version 0.1
    @see https://tdn.totvs.com/pages/releaseview.action?pageId=6085400
/*/

User Function MT100TOK()

	Local lRet := PARAMIXB[1]

	if ExistBlock("VALENTPRD")
		lRet := ExecBlock("VALENTPRD",.F.,.F.,PARAMIXB)
	endif

Return  lRet
