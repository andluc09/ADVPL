#INCLUDE 'TOTVS.CH' 

/*/{Protheus.doc} User Function MT110TOK
    Exerc�cio | Ponto de Entrada: MT110TOK - Confirma a grava��o Solicita��o de Compra
    @type  Function
    @author Andr� Lucas
    @since 15/12/2023
    @version 0.1
    @see https://tdn.totvs.com/display/public/PROT/MT110TOK
/*/

User Function MT110TOK()

    Local lRet := .F.

    if ExistBlock('QTDXPRC', .F., .F.)
        lRet := ExecBlock('QTDXPRC', .F., .F., 'C1_ZZPRCSG')
    endif

Return lRet
