#INCLUDE 'TOTVS.CH'

/*/{Protheus.doc} User Function M460FIM
    4. Exercício | Inicializador Padrão e inicializador de Browse
    @type  Function
    @author André Lucas
    @since 24/08/2023
    @version 0.1
    @see https://tdn.totvs.com/pages/releaseview.action?pageId=6784180
/*/

User Function ZZNMFOR()

    Local cRet := ""

    if(ALLTRIM(Posicione("SF1", 2, xFilial("SF1") + SF1->F1_FORNECE + SF1->F1_LOJA + SF1->F1_DOC,"F1_TIPO"))<>"B/D")
        cRet := Posicione("SA2", 1, xFilial("SA2") + SF1->F1_FORNECE + SF1->F1_LOJA, "A2_NOME")
    else
        cRet := Posicione("SA1", 1, xFilial("SA1") + SF1->F1_FORNECE + SF1->F1_LOJA, "A1_NOME")
    endif

Return cRet
