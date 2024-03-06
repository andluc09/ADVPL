#INCLUDE 'TOTVS.CH'

/*/{Protheus.doc} User Function MT103FIM
    Exercício | Interfaces Visual - MSDIALOG()
    @type  Function
    @author André Lucas
    @since 11/12/2023
    @version 0.1
    @see https://tdn.totvs.com/pages/releaseview.action?pageId=24346988
    @see https://tdn.totvs.com/pages/releaseview.action?pageId=24346994
    @see https://tdn.totvs.com/pages/releaseview.action?pageId=24347069
    @see https://tdn.totvs.com/pages/releaseview.action?pageId=24347074
    @see https://tdn.totvs.com/pages/releaseview.action?pageId=23889154
/*/

User Function RetEntr()

    Local oDlg        := NIL
    Local nOpcao      := PARAMIXB
    Local cTitle      := 'Retirada e Entrega' 
    Local aArea       := GetArea()
    Local aAreaSF1    := SF1->(GetArea())
    Private dRetGet   := SPACE(10)
    Private cHrRetGet := SPACE(5)
    Private dEntGet   := SPACE(10)
    Private cHrEntGet := SPACE(5)
    Private dRetPdr   := SPACE(10)
    Private cHrRetPdr := SPACE(5)
    Private dEntPdr   := SPACE(10)
    Private cHrEntPdr := SPACE(5)

    dRetGet   := SF1->F1_ZZDTRET
    cHrRetGet := SF1->F1_ZZHRRET
    dEntGet   := SF1->F1_ZZDTENT
    cHrEntGet := SF1->F1_ZZHRENT

    DEFINE MSDIALOG oDlg TITLE cTitle FROM 000, 000 TO 230, 250 FONT oFont := TFont():New('Arial',,-13,.T.)  PIXEL

    @ 010, 010 SAY "Data Retirada: "                            SIZE 065, 007 OF oDlg PIXEL
    @ 007, 060 MSGET dRetPdr VAR dRetGet                        SIZE 050, 010 OF oDlg PIXEL;
    VALID IIF(nOpcao <> 2, dRetGet, dRetGet := NIL);
    WHEN IIF(nOpcao <> 2, M->dRetGet, IIF(Empty(M->dRetGet),!Empty(M->dRetGet), Empty(M->dRetGet)))

    @ 025, 010 SAY "Hora Retirada: "                            SIZE 065, 007 OF oDlg PIXEL
    @ 023, 060 MSGET cHrRetPdr VAR cHrRetGet PICTURE "@E 99:99" SIZE 030, 010 OF oDlg PIXEL;
    VALID IIF(nOpcao <> 2, AtVldHora(M->cHrRetGet), cHrRetGet := NIL);
    WHEN IIF(nOpcao <> 2, M->cHrRetGet, IIF(Empty(M->cHrRetGet),!Empty(M->cHrRetGet), Empty(M->cHrRetGet)))

    @ 053, 010 SAY "Data Entrega: "                             SIZE 065, 007 OF oDlg PIXEL
    @ 050, 060 MSGET dEntPdr VAR dEntGet                        SIZE 050, 010 OF oDlg PIXEL;
    VALID IIF(nOpcao <> 2, dEntGet, dEntGet := NIL);
    WHEN IIF(nOpcao <> 2, M->dEntGet, IIF(Empty(M->dEntGet),!Empty(M->dEntGet), Empty(M->dEntGet)))

    @ 068, 010 SAY "Hora Entrega: "                             SIZE 065, 007 OF oDlg PIXEL
    @ 065, 060 MSGET cHrEntPdr VAR cHrEntGet PICTURE "@E 99:99" SIZE 030, 010 OF oDlg PIXEL;
    VALID IIF(nOpcao <> 2, AtVldHora(M->cHrEntGet), cHrEntGet := NIL);
    WHEN IIF(nOpcao <> 2, M->cHrEntGet, IIF(Empty(M->cHrEntGet),!Empty(M->cHrEntGet), Empty(M->cHrEntGet)))

    @ 095, 020 BUTTON "Confirmar" SIZE 037, 012 OF oDlg PIXEL;
    ACTION (SalvaRetEntr(), oDlg:End())
    @ 095, 074 BUTTON "Cancelar"  SIZE 037, 012 OF oDlg PIXEL;
    ACTION (FwAlertWarning('<b>Cancelado</b> pelo usuário!', 'CANCELADO'), oDlg:End())

    ACTIVATE MSDIALOG oDlg CENTERED 

    RestArea(aAreaSF1)
    RestArea(aArea)

Return

Static Function SalvaRetEntr()

	dbSelectArea("SF1")
		RecLock("SF1",.F.)  
		SF1->F1_ZZDTRET	:= dRetGet
		SF1->F1_ZZHRRET := cHrRetGet
		SF1->F1_ZZDTENT	:= dEntGet
		SF1->F1_ZZHRENT := cHrEntGet
	MsUnlock()

Return
