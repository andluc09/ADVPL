#INCLUDE 'TOTVS.CH'

/*/{Protheus.doc} User Function Tratamento
    5. Exerc�cio | Modo Edi��o: (X3_WHEN) Tratamento
    @type  Function
    @author Andr� Lucas
    @since 29/08/2023
    @version 0.1
    @see https://terminaldeinformacao.com/2018/06/19/funcao-para-deixar-codigo-produto-sequencial-conforme-grupo/
/*/

User Function Tratamento()

    Local lRet := .T.

    if((Posicione('SBM',1,xFilial('SBM')+SBM->BM_GRUPO,'BM_ZZSEQ') $ 'N') .OR. EMPTY(M->B1_GRUPO))
        lRet := .T.
    elseif ((Posicione('SBM',1,xFilial('SBM')+SBM->BM_GRUPO,'BM_ZZSEQ') $ 'S') .AND. !EMPTY(M->B1_COD))
        lRet := .F.
    elseif ((Posicione('SBM',1,xFilial('SBM')+SBM->BM_GRUPO,'BM_ZZSEQ') $ 'S') .AND. !EMPTY(M->B1_GRUPO))
        lRet := .T.
    endif

Return lRet
