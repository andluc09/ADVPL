#INCLUDE 'TOTVS.CH'

/*/{Protheus.doc} User Function MT103FIM
    Exercício | Ponto de Entrada: MT103FIM
    @type  Function
    @author André Lucas
    @since 11/12/2023
    @version 0.1
    @see https://tdn.totvs.com/pages/releaseview.action?pageId=6085406
/*/

User Function MT103FIM()

    Local nOpcao    := PARAMIXB[1] //? 2 - Visualizar, 3 - Incluir e 4 - Classificar
    Local nConfirma := PARAMIXB[2] //? 0 - igual a Cancelar (.F.) | 1 - igual a Confirmar (.T.)

    if nConfirma <> 0
        if ExistBlock('RetEntr')
            ExecBlock('RetEntr', .F., .F., nOpcao)
        endif
    endif

Return
