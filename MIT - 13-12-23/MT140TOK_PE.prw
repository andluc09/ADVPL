#INCLUDE 'TOTVS.CH'

/*/{Protheus.doc} User Function MT140TOK [TRANSACTION - TRANSA��O]
    6. Exerc�cio | Ponto de Entrada: MT140TOK - Valida todos os �tens do Pr�-Documento (Pr�-Nota)
    @type  Function
    @author Andr� Lucas
    @since 13/12/2023
    @version 0.1
    @see https://tdn.totvs.com/pages/releaseview.action?pageId=6085513
/*/

User Function MT140TOK()

	Local lRet := PARAMIXB[1]

	if ExistBlock("VALENTPRD")
		lRet := ExecBlock("VALENTPRD",.F.,.F.,PARAMIXB)
	endif

Return  lRet
