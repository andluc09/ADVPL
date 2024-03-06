#INCLUDE 'TOTVS.CH'

/*/{Protheus.doc} User Function MT100LOK [LOAD - CARREGAMENTO]
    6. Exerc�cio | Ponto de Entrada: MT100LOK- Altera��es de Itens da NF de Despesas de Importa��o (Documento de Entrada)
    @type  Function
    @author Andr� Lucas
    @since 13/12/2023
    @version 0.1
    @see https://tdn.totvs.com/pages/releaseview.action?pageId=6085397
/*/

User Function MT100LOK()

	Local lRet := PARAMIXB[1]

	if ExistBlock("VALENTPRD")
		lRet := ExecBlock("VALENTPRD",.F.,.F.,PARAMIXB)
	endif

Return  lRet
