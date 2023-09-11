#INCLUDE 'TOTVS.CH'

/*/{Protheus.doc} User Function M460FIM
    4. Exercício | Ponto de Entrada: M460FIM
    @type  Function
    @author André Lucas
    @since 24/08/2023
    @version 0.1
    @see https://tdn.totvs.com/pages/releaseview.action?pageId=6784180
/*/

User Function M460FIM()

    dbSelectArea("SC5")
    dbSetOrder(1)

    if(dbSeek(xFilial("SC5") + SC5->C5_NUM))    
        RecLock("SF2", .F.)
            SF2->F2_ZZNMCLI := SC5->C5_ZZNMCLI
        ("SF2")->(MsUnlock())  
    endif

Return 
