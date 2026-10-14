      * Projet perso : gestion de comptes bancaires en COBOL
      * Le programme lit les comptes et les operations du jour,
      * met a jour les soldes et affiche un recap.
       identification division.
       program-id. banque.

       environment division.
       input-output section.
       file-control.
           select f-comptes assign to "comptes.txt"
               organization is line sequential.
           select f-operations assign to "operations.txt"
               organization is line sequential.
           select f-resultat assign to "comptes_maj.txt"
               organization is line sequential.

       data division.
       file section.
       fd f-comptes.
       01 compte-enr.
           05 c-numero      pic 9(5).
           05 c-nom         pic x(20).
           05 c-solde       pic 9(7)v99.

       fd f-operations.
       01 operation-enr.
           05 o-numero      pic 9(5).
           05 o-type        pic x.
           05 o-montant     pic 9(5)v99.

       fd f-resultat.
       01 resultat-enr      pic x(34).

       working-storage section.
      * tableau pour garder les comptes en memoire
       01 table-comptes.
           05 t-compte occurs 50 times.
               10 t-numero  pic 9(5).
               10 t-nom     pic x(20).
               10 t-solde   pic 9(7)v99.

       01 nb-comptes        pic 99 value 0.
       01 i                 pic 99.
       01 trouve            pic 99.
       01 fin-fichier       pic x value "n".

       01 nb-ok             pic 999 value 0.
       01 nb-erreurs        pic 999 value 0.

      * pour afficher les montants proprement
       01 montant-aff       pic z(6)9.99.
       01 solde-aff         pic z(6)9.99.

       procedure division.
       debut.
           display "===== GESTION BANCAIRE ====="
           perform charger-comptes
           perform traiter-operations
           perform afficher-soldes
           perform sauvegarder
           display " "
           display "operations ok      : " nb-ok
           display "operations refusees: " nb-erreurs
           stop run.

      * on lit tout le fichier des comptes dans le tableau
       charger-comptes.
           open input f-comptes
           move "n" to fin-fichier
           perform until fin-fichier = "o"
               read f-comptes
                   at end
                       move "o" to fin-fichier
                   not at end
                       add 1 to nb-comptes
                       move c-numero to t-numero(nb-comptes)
                       move c-nom    to t-nom(nb-comptes)
                       move c-solde  to t-solde(nb-comptes)
               end-read
           end-perform
           close f-comptes
           display nb-comptes " comptes charges".

       traiter-operations.
           display " "
           display "--- operations du jour ---"
           open input f-operations
           move "n" to fin-fichier
           perform until fin-fichier = "o"
               read f-operations
                   at end
                       move "o" to fin-fichier
                   not at end
                       perform une-operation
               end-read
           end-perform
           close f-operations.

       une-operation.
      * on cherche le compte dans le tableau
           move 0 to trouve
           perform varying i from 1 by 1 until i > nb-comptes
               if t-numero(i) = o-numero
                   move i to trouve
               end-if
           end-perform

           move o-montant to montant-aff

           if trouve = 0
               display "compte " o-numero " introuvable -> refuse"
               add 1 to nb-erreurs
           else
               evaluate o-type
                   when "D"
                       add o-montant to t-solde(trouve)
                       display "depot   " o-numero " " montant-aff
                       add 1 to nb-ok
                   when "R"
      * pas de decouvert autorise
                       if o-montant > t-solde(trouve)
                           display "retrait " o-numero " " montant-aff
                                   " -> solde insuffisant"
                           add 1 to nb-erreurs
                       else
                           subtract o-montant from t-solde(trouve)
                           display "retrait " o-numero " " montant-aff
                           add 1 to nb-ok
                       end-if
                   when other
                       display "type " o-type " inconnu -> refuse"
                       add 1 to nb-erreurs
               end-evaluate
           end-if.

       afficher-soldes.
           display " "
           display "--- soldes apres traitement ---"
           perform varying i from 1 by 1 until i > nb-comptes
               move t-solde(i) to solde-aff
               display t-numero(i) " " t-nom(i) " " solde-aff
           end-perform.

      * on ecrit les nouveaux soldes dans un autre fichier
       sauvegarder.
           open output f-resultat
           perform varying i from 1 by 1 until i > nb-comptes
               write resultat-enr from t-compte(i)
           end-perform
           close f-resultat.
