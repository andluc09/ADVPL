#INCLUDE 'TOTVS.CH' 

/*/{Protheus.doc} User Function MTA105OK
    2. Exercício | Ponto de Entrada: MTA105OK
    @type  Function
    @author André Lucas
    @since 17/08/2023
    @version 0.1
    @see https://tdn.totvs.com/pages/releaseview.action?pageId=6087792
    /*/

User Function MTA105OK()

    Local lRet := .F.

    if ExistBlock('QTXPRARM', .F., .F.)
        lRet := ExecBlock('QTXPRARM', .F., .F.)
    endif

Return lRet
