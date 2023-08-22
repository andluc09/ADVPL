#INCLUDE 'TOTVS.CH' 

/*/{Protheus.doc} User Function MT110TOK
    2. Exercício | Ponto de Entrada: MT110TOK
    @type  Function
    @author André Lucas
    @since 17/08/2023
    @version 0.1
    @see https://tdn.totvs.com/display/public/PROT/MT110TOK
    /*/

User Function MT110TOK()

    Local lRet := .F.

    if ExistBlock('QTDXPRC', .F., .F.)
        lRet := ExecBlock('QTDXPRC', .F., .F.)
    endif

Return lRet
