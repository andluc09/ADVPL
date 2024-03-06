#INCLUDE 'TOTVS.CH' 

/*/{Protheus.doc} User Function MTA105OK
    Exercício | Ponto de Entrada: MTA105OK - Confirma a gravação da solicitação ao almoxarifado (Armazém)
    @type  Function
    @author André Lucas
    @since 15/12/2023
    @version 0.1
    @see https://tdn.totvs.com/pages/releaseview.action?pageId=6087792
/*/

User Function MTA105OK()

    Local lRet := .F.

    if ExistBlock('QTDXPRC', .F., .F.)
        lRet := ExecBlock('QTDXPRC', .F., .F., 'CP_ZZPRCSG')
    endif

Return lRet
