#INCLUDE 'TOTVS.CH'

/*/{Protheus.doc} User Function MT140LOK [LOAD - CARREGAMENTO]
    6. Exercício | Ponto de Entrada: MT140LOK - Valida informações no pré-documento de entrada (Pré-Nota)
    @type  Function
    @author André Lucas
    @since 13/12/2023
    @version 0.1
    @see https://tdn.totvs.com/pages/releaseview.action?pageId=6085509
/*/

User Function MT140LOK()

	Local lRet := PARAMIXB[1]

	if ExistBlock("VALENTPRD")
		lRet := ExecBlock("VALENTPRD",.F.,.F.,PARAMIXB)
	endif

Return  lRet
