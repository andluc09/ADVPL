#INCLUDE 'TOTVS.CH'

/*/{Protheus.doc} User Function MT100LOK
    6. Exercício | Ponto de Entrada: MT100LOK
    @type  Function
    @author André Lucas
    @since 31/08/2023
    @version 0.1
    @see https://tdn.totvs.com/pages/releaseview.action?pageId=6085397
/*/

User Function MT100LOK()

	Local lRet		:= PARAMIXB[1]

	if ExistBlock("VALENTPRD")
		lRet := ExecBlock("VALENTPRD",.F.,.F.,PARAMIXB)
	endif

Return  lRet
