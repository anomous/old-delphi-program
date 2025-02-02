unit extraire;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, ComCtrls, StdCtrls;

type
  TextraireArchive = class(TForm)
    Label1: TLabel;
    fichierEnCours: TLabel;
    Annuler: TButton;
    Suspendre: TButton;
    Reduire: TButton;
    ProgressBar1: TProgressBar;
    StartEncode: TTimer;
    procedure StartEncodeTimer(Sender: TObject);
    procedure AnnulerClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure ReduireClick(Sender: TObject);
    procedure SuspendreClick(Sender: TObject);
  private
    { D�clarations priv�es}
    { Indique si l'on doit quitter la fen�tre }
    toClose : Boolean ;
    { Nombre de fichier � mettre dans l'archive }
    NbFile : Integer ;
    { Num�ro du fichier en cours }
    NumFile : Integer ;
        
    procedure IgnoreExctractUUEncode(Var fichierALire : TextFile) ;
    function ExtractUUEncode(nomDeSortie : String; repertoireDestination : String; Var fichierALire : TextFile) : Boolean;
    function IsFileInList(nomFichier : String) : Boolean ;
    function CutString(texte : String) : String ;        
  public
    { D�clarations publiques}
  end;

var
  extraireArchive: TextraireArchive;

implementation

uses main, attendre;

{$R *.DFM}


{*******************************************************************************
 * D�code tous les fichiers contenu dans une archive
 *
 * Entr�e : archive, r�pertoire de destination
 * Sortie : aucune
 * Retour : True si ok, False sinon
 ******************************************************************************}
procedure TextraireArchive.StartEncodeTimer(Sender: TObject);
//function TmainForm.UUDecodeFile(nomFichierAlire : String; repertoireDestination : string) : Boolean ;
Var fichierALire : TextFile ;
    ligne, debutLigne, nomDeSortie : String ;
    retourMessageBox : Integer ;
begin
    NbFile := Form1.ListView1.SelCount ;

    if NbFile  > 0
    then begin
        NumFile := 1 ;
            
        AssignFile(fichierALire, Form1.nomArchive) ;
        FileMode := 0 ;
        Reset(fichierALire) ;

        { D�salcive le timer }
        StartEncode.Enabled := False ;

        while not Eof(fichierALire) do
        begin
            ReadLn(fichierALire, ligne) ;
            ligne := Trim(ligne) ;
            debutLigne := LowerCase(Form1.StrCopyN(ligne, 5)) ;

            if debutLigne = 'begin'
            then begin
                 nomDeSortie := Form1.StrCopyToN(ligne, 11) ;

                 if (IsFileInList(nomDeSortie))
                 then begin
                     fichierEnCours.Caption := CutString(nomDeSortie) + ' (' + IntToStr(NumFile) + '/' + IntToStr(NbFile) + ')' ;
                     UpdateWindow(Self.Handle) ;
                     ProgressBar1.Position := NumFile * 100 div NbFile ;

                     { V�rifie que le fichier de destination n'existe pas }
                     if (FileExists(Form1.pathFile + nomDeSortie))
                     then begin
                         retourMessageBox := Application.MessageBox(PChar('Le fichier ' + Form1.pathFile + nomDeSortie + ' existe d�j�. Voulez-vous le remplacer ?'), 'Fichier d�j� existant', MB_ICONQUESTION + MB_YESNOCANCEL) ;

                         if (retourMessageBox = IDYES)
                         then begin
                             { Remplace le fichier }
                             if ExtractUUEncode(nomDeSortie, Form1.pathFile, fichierALire) = False
                             then begin
                                 CloseFile(fichierALire) ;
                                 exit ;
                             end
                         end
                         else if (retourMessageBox = IDNO)
                         then
                             IgnoreExctractUUEncode(fichierALire)
                         else begin
                             CloseFile(fichierALire) ;
                             { Quitte la fonction }
                             exit ;
                         end ;
                     end
                     else begin
                         if ExtractUUEncode(nomDeSortie, Form1.pathFile, fichierALire) = False
                         then begin
                             CloseFile(fichierALire) ;
                             exit ;
                         end ;
                     end ;

                     NumFile := NumFile + 1 ;
                 end
                 else
                     IgnoreExctractUUEncode(fichierALire) ;

                 { Si on doit quitter la fen�tre }
                 if toClose = True
                 then begin
                     {Ferme les fichiers }
                     {$I-}
                     { On supprime la gestion des erreurs car le fichier peut ou
                       non �tre ouvert. Impossible d'en �tre s�r }
                     CloseFile(FichierALire) ;
                     {$I+}
                     Break ;
                 end
                 else begin
                     { Lit une ligne. Normalement le end }
                     ReadLn(fichierALire, ligne) ;
                     ligne := LowerCase(ligne) ;

                     if ligne <> 'end'
                     then
                         Form1.ListeErreurs.Lines.Append('La ligne "end" n''a pas �t� d�tect�e � la fin des donn�es pour le fichier ' + nomDeSortie) ;
                 end ;
            end ;
        end ;

        if toClose <> True
        then
            CloseFile(fichierALire) ;
    end ;
    
    Close ;
end ;

{*******************************************************************************
 * Ignore le flux de donn�e en cours
 *
 * Entr�e : Fichier � lire
 * Sortie : aucune
 * Retour : auncun
 ******************************************************************************}
procedure TextraireArchive.IgnoreExctractUUEncode(Var fichierALire : TextFile) ;
Var ligneEnCours : String ;
begin
    repeat
        ReadLn(fichierALire, ligneEnCours) ;
        ligneEnCours := Trim(ligneEnCours) ;
        Application.ProcessMessages ;

        { Si on doit quitter la fen�tre }
        if toClose = True
        then begin
            {Ferme les fichiers }
            CloseFile(FichierALire) ;
            Exit ;
        end ;

    until ligneEnCours = '`';   { Si on rencontre une ligne vide, on l'ignore}
end ;

{*******************************************************************************
 * D�code les information dans un fichier � partir de la position de la derni�re
 * ligne.
 * Apr�s appel de la fonction, si tout c'est bien pass�, la ligne courante du
 * fichier est la ligne end.
 *
 * Entr�e : Nom de sortie du fichier, r�pertoire de de destination, fichier � lire
 * Sortie : aucune
 * Retour : False en cas d'erreur
 ******************************************************************************}
function TextraireArchive.ExtractUUEncode(nomDeSortie : String; repertoireDestination : String; Var fichierALire : TextFile) : Boolean;
Var Buffer : Array[0..45] of Byte;
    ligneEncours : String ;
    fichierAEcrire : File ;
    longueurLigneEnCours : Integer ;
    longueurPresume : Integer ;
    longueurBuffer : Integer ;
    tailleFichier  : Integer ;
    i, j : Integer ;
    c1, c2, c3, c4 : Byte ;
    nbCarEcrit : Integer ;
begin
    Result := True ;

    { Ouvre le fichier a �crire }
    AssignFile(fichierAEcrire, repertoireDestination + nomDeSortie) ;
    Rewrite(fichierAEcrire, 1) ;

    { Initialise la taille du fichier � 0 }
    tailleFichier := 0 ;

    repeat
        { Lit une ligne du fichier }
        repeat
            ReadLn(fichierALire, ligneEnCours) ;
            ligneEnCours := Trim(ligneEnCours) ;

            if ligneEnCours = ''
            then
                 form1.ListeErreurs.Lines.Append('Une ligne vide a �t� d�tect�e dans le flux de donn�es du fichier ' + nomDeSortie + '. Ligne ignor�e.') ;

        until ligneEnCours <> '';   { Si on rencontre une ligne vide, on l'ignore}

        ligneEnCours := Trim(ligneEncours) ;

        if (ligneEnCours <> '`')
        then begin
            longueurLigneEncours := length(ligneEnCours) ;

            { Si le premier caract�re est compris entre '!' et 'M' }
            if (Ord(ligneEnCours[1]) > $20) and (Ord(ligneEnCours[1]) < $4E)
            then begin
                { Calcule la longueur des donn�es de la ligne }
                longueurBuffer := Form1.CodeOfUUD(ligneEnCours[1]) ;

                { Calcule la longueur pr�sum� de la ligne.
                  Longueur des donn�es /3 * 4 -> transcrit 3 caract�re pour 4.
                  Il faut ajouter 4 caract�res s'il y a une reste. + 1 pour l'
                  octet de longueur. }
                longueurPresume := ((longueurBuffer div 3) * 4) + 1 ;

                if (longueurBuffer mod 3) > 0
                then
                    longueurPresume := longueurPresume + 4 ;

                if longueurPresume <> longueurLigneEncours
                then begin
                    Form1.ListeErreurs.Lines.Append('La longueur indiqu� par l''indicateur de longueur de la ligne ne correspond pas � la longueur r�elle de la ligne. Ligne ignor�e.') ;
                end
                else begin
                    tailleFichier := tailleFichier + longueurBuffer ;

                    i := 2 ;
                    j := 0 ;

                    repeat
                        c1 := Form1.CodeOfUUD(ligneEncours[i]) ;
                        c2 := Form1.CodeOfUUD(ligneEncours[i + 1]) ;
                        c3 := Form1.CodeOfUUD(ligneEncours[i + 2]) ;
                        c4 := Form1.CodeOfUUD(ligneEncours[i + 3]) ;

                        Buffer[j] := (c1 shl 2) or ((c2 and 48) shr 4) ;
                        Buffer[j + 1] := ((c2 and 15) shl 4) or (c3 shr 2) ;
                        Buffer[j + 2] := ((c3 and 3) shl 6) or c4 ;

                        i := i + 4 ;
                        j := j + 3 ;
                    until (i >= longueurLigneEnCours) ;

                    BlockWrite(fichierAEcrire, Buffer, longueurBuffer, nbCarEcrit) ;
                end ;
            end
            else
                Form1.ListeErreurs.Lines.Append('Un indicateur de longueur de ligne est erron� dans le flux de donn�es du fichier ' + nomDeSortie + '. Ligne ignor�e.') ;

            { Si on doit quitter la fen�tre }
            if toClose = True
            then begin
                {Ferme les fichiers }
                CloseFile(FichierALire) ;
                CloseFile(FichierAEcrire) ;
                Exit ;
            end ;
        end ;
        
        Application.ProcessMessages ;
    until (ligneEnCours = '`') ;

    { V�rifie que la taille extaite du fichier est la taille sur le disque dur }
    if FileSize(fichierAEcrire) <> tailleFichier
    then
        if Application.MessageBox(PChar('La taille des donn�es extraites du fichier ' + repertoireDestination + nomDeSortie + ' ne correspondent pas � sa taille sur le disque ! Voulez-vous continuer l''extraction ?'#10#13'(Le fichier ne sera pas supprim�)'), 'Erreur', MB_ICONERROR + MB_YESNO) = IDNO
        then
             Result := False ;

    CloseFile(fichierAEcrire) ;
end ;

{*******************************************************************************
 * V�rifie si le fichier en cours est dans la liste des fichiers s�lectionn�s
 *
 * Entr�e : Nom du fichier
 * Sortie : aucune
 * Retour : true si trouv�, false sinon
 ******************************************************************************}
function TextraireArchive.IsFileInList(nomFichier : String) : Boolean ;
Var ItemEnCours : TListItem ;
    i : Integer ;
begin
    Result := False ;

    For i := 0 to Form1.ListView1.SelCount - 1 do
    Begin
        if i = 0
        then
            ItemEnCours := Form1.ListView1.Selected
        else
            ItemEnCours := Form1.ListView1.GetNextItem(ItemEnCours, sdBelow, [isSelected]) ;

        if ItemEnCours <> nil
        then
            if ItemEnCours.Caption = nomFichier
            then begin
                Result := True ;
                exit
            end ;
    end ;
end ;

procedure TextraireArchive.AnnulerClick(Sender: TObject);
begin
    toClose := True ;
end;

procedure TextraireArchive.FormResize(Sender: TObject);
begin
    { R�affiche toute les fen�tres }
    Form1.WindowState := wsNormal ;
    WindowState := wsNormal ;
end;

procedure TextraireArchive.ReduireClick(Sender: TObject);
begin
    { R�duit toute les fen�tres }
    Form1.WindowState := wsMinimized ;
    WindowState := wsMinimized ;
end;

procedure TextraireArchive.SuspendreClick(Sender: TObject);
Var attendre : Tattente ;
begin
    { Cr�er la fen�tre d'attente }
    attendre := Tattente.Create(Self) ;
    { Copie le label des fichiers }
    attendre.fichierEnCours.Caption := fichierEnCours.Caption ;
    { Copie la barre de progression }
    attendre.ProgressBar1.Position := ProgressBar1.Position ;
    { Pointe sur la variable }
    attendre.toClose := @toClose ;
    { Label caption }
    attendre.Label1.Caption := Label1.Caption ;
        
    Visible := False ;

    attendre.ShowModal ;
    attendre.Free ;
        
    Visible := True ;
end;

{*******************************************************************************
 * Coupe le nom du fichier pour l'affichage
 *
 * Entr�e : texte contenant le nom du fichier
 * Sortie : auncune
 * Retour : le texte qu'il faut afficher
 ******************************************************************************}
function TextraireArchive.CutString(texte : String) : String ;
Var i : Integer ;
    longueurChaine : Integer ;
begin
    Result := '' ;
    longueurChaine := length(texte) ;

    if longueurChaine > 36
    then begin
        { On coupe le texte }
        { On copie le 20 premier caract�res }
        For i := 1 to 16 do
            Result := Result + Texte[i] ;

        { le ... }
        Result := Result + ' ... ' ;

        { On copie le 20 premier caract�res }
        For i := (longueurChaine - 16) to longueurChaine do
            Result := Result + Texte[i] ;
    end
    else
        Result := Texte ;

end ;

end.
