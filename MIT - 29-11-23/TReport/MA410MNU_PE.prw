#INCLUDE 'TOTVS.CH'

/*/{Protheus.doc} User Function MA410MNU
    3. Exercício | Ponto de Entrada: MA410MNU
    @type  Function
    @author André Lucas
    @since 18/08/2023
    @version 0.1
    @see https://tdn.totvs.com/display/public/PROT/MA410MNU
/*/

User Function MA410MNU()

    //? Opção: 6. Habilita Menu Funcional

    if ExistBlock('RelPdVnd')
        AADD(aRotina, {'Rel. Ped. de Vendas', 'U_RelPdVnd(.T.)', 0, 6, 0, NIL})
    endif

Return 
