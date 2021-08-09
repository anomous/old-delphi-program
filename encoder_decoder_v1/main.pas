unit main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ficheErreurs;

type
  TmainForm = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    Edit2: TEdit;
    Button2: TButton;
    Edit3: TEdit;
    Label2: TLabel;
    Edit4: TEdit;
    CheckBox1: TCheckBox;
    ListeErreurs: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { D�clarations priv�es}
    function UUEncodeFile(nomFichierAEncoder : String; nomFichierDestination : String; AppendVar : Boolean) : Boolean;
    function CodeOfUUE(Octet : Byte) : String ;
    function UUDecodeFile(nomFichierAlire : String; repertoireDestination : string) : Boolean ;
    function StrCopyN(chaine : String; valMax : Integer) : String ;
    function StrCopyToN(chaine : String; startPos : Integer) : String ;
    function ExtractUUEncode(nomDeSortie : String; repertoireDestination : String; Var fichierALire : TextFile) : Boolean;
    function CodeOfUUD(Octet : String) : Byte ;
    procedure IgnoreExctractUUEncode(Var fichierALire : TextFile) ;
    procedure ShowErrorIfExists() ;    
  public
    { D�clarations publiques}
  end;


var
  mainForm: TmainForm;
  FichierErreur : TFicheErreur ;

implementation

{$R *.DFM}

{*******************************************************************************
 * Lit un fichier et l'encode en l'enregstrant dans un autres fichiers.
 *
 * Entr�e : nom du fichier � encoder, nom du fichier destination
 * Sortie : aucune
 * Retour : True si aucune erreur, False sinon
 ******************************************************************************}
function TmainForm.UUEncodeFile(nomFichierAEncoder : String; nomFichierDestination : String;  AppendVar : Boolean) : Boolean ;
Var FichierALire : File ;
    FichierAEcrire : TextFile ;
    NbDeCarLu : Integer ;
    Buffer : Array[0..44] of Byte ;
    ChaineEncodee : String[64] ;
    i : Integer ;
    c1, c2, c3 : Byte ;
begin
    Result := True ;

    { Ouvre le fichier � lire }
    AssignFile(FichierALire, nomFichierAEncoder) ;
    Reset(FichierALire, 1) ;          { voir ce qui se passe � 45 au lieu de 1 }

    { Ouvre le fichier � �crire }
    AssignFile(FichierAEcrire, nomFichierDestination) ;

    if (AppendVar = True)
    then
        Append(FichierAEcrire)
    else
        Rewrite(FichierAEcrire) ;

    { Ecrit l'ent�te }
    WriteLn(FichierAEcrire, 'begin 666 ' + ExtractFileName(nomFichierAEncoder)) ;

    repeat
        { Lit 45 Caract�res }
        BlockRead(FichierALire, Buffer, 45, NbDeCarLu) ;

        { Configure le premier caract�re en fonction du nombre de caract�res
          lu. Espace + NbDeCarLu }
        ChaineEncodee := Char($20 + NbDeCarLu) ;

        { Encode les caract�re }
        i := 0 ;
        repeat
            { D�finit la valeur du premier octet � encoder }
            if i < NbDeCarLu
            then
                c1 := Buffer[i]
            else
                c1 := 0 ;

            { D�finit la valeur du premier deuxi�me � encoder }
            if ((i + 1) < NbDeCarLu)
            then
                c2 := Buffer[i + 1]
            else
                c2 := 0 ;

            { D�finit la valeur du troisi�me octet � encoder }
            if ((i + 2) < NbDeCarLu)
            then
                c3 := Buffer[i + 2]
            else
                c3 := 0 ;

            ChaineEncodee := ChaineEncodee + CodeOfUUE(c1 shr 2) + CodeOfUUE(((c1 and 3) shl 4) or ((c2 shr 4) and 15)) + CodeOfUUE(((c2 shl 2) and 60) or ((c3 shr 6) and 3)) + CodeOfUUE(c3 and 63);

            { Saute aux trois prochains caract�res }
            i := i + 3 ;
        until (i >= NbDeCarLu) ; { On encode tant qu'on n'a pas tout encod� }

        { Ecrit la chaine encod�e }
        WriteLn(FichierAEcrire, ChaineEncodee) ;
    until (NbDeCarLu < 45) ; { S'il  a moins de 45 caract�res, c'est qu'on est � la fin du fichier }

    { Ecrit le pied de page }
    WriteLn(FichierAEcrire, '`') ;
    WriteLn(FichierAEcrire, 'end') ;

    {Ferme les fichiers }
    CloseFile(FichierALire) ;
    CloseFile(FichierAEcrire) ;
end ;

procedure TmainForm.Button1Click(Sender: TObject);
begin
    if (FileExists(Edit1.Text))
    then begin
        UUEncodeFile(Edit1.Text, Edit2.Text, CheckBox1.Checked) ;
        ShowErrorIfExists() ;
    end
    else
       Application.MessageBox(PChar('Le fichier ' + Edit1.Text + ' est introuvable !'), 'Fichier introuvable', MB_OK + MB_ICONERROR) ;

end;

{*******************************************************************************
 * Encode un caract�re en UUE
 *
 * Entr�e : Octet � encoder
 * Sortie : aucune
 * Retour : Chaine de caract�re contenant l'octet
 ******************************************************************************}
function TmainForm.CodeOfUUE(Octet : Byte) : String ;
begin
    if (Octet <> 0)
    then
        Result := Chr(Octet + $20)  { Octet + Espace }
    else
        Result := '`' ;
end ;

procedure TmainForm.Button2Click(Sender: TObject);
begin
    if (FileExists(Edit3.Text))
    then begin
        UUDecodeFile(Edit3.Text, Edit4.Text) ;
        ShowErrorIfExists() ;
    end
    else
        Application.MessageBox(PChar('Le fichier ' + Edit3.Text + ' est introuvable !'), 'Fichier introuvable', MB_OK + MB_ICONERROR) ;
end;

{*******************************************************************************
 * D�code tous les fichiers contenu dans une archive
 *
 * Entr�e : archive, r�pertoire de destination
 * Sortie : aucune
 * Retour : True si ok, False sinon
 ******************************************************************************}
function TmainForm.UUDecodeFile(nomFichierAlire : String; repertoireDestination : string) : Boolean ;
Var fichierALire : TextFile ;
    ligne, debutLigne, nomDeSortie : String ;
    retourMessageBox : Integer ;
begin

    Result := True ;

    AssignFile(fichierALire, nomFichierALire) ;
    Reset(fichierALire) ;

    while not Eof(fichierALire) do
    begin
        ReadLn(fichierALire, ligne) ;
        ligne := Trim(ligne) ;
        debutLigne := LowerCase(StrCopyN(ligne, 5)) ;

        if debutLigne = 'begin'
        then begin
             nomDeSortie := StrCopyToN(ligne, 11) ;

             { V�rifie que le fichier de destination n'existe pas }
             if (FileExists(repertoireDestination + nomDeSortie))
             then begin
                 retourMessageBox := Application.MessageBox(PChar('Le fichier ' + repertoireDestination + nomDeSortie + ' existe d�j�. Voulez-vous le remplacer ?'), 'Fichier d�j� existant', MB_ICONQUESTION + MB_YESNOCANCEL) ;

                 if (retourMessageBox = IDYES)
                 then begin
                     { Remplace le fichier }
                     if ExtractUUEncode(nomDeSortie, repertoireDestination, fichierALire) = False
                     then begin
                         Result := False ;
                         CloseFile(fichierALire) ;                         
                         exit ;
                     end
                 end
                 else if (retourMessageBox = IDNO)
                 then
                     IgnoreExctractUUEncode(fichierALire)
                 else begin
                     Result := False ;
                     CloseFile(fichierALire) ;
                     { Quitte la fonction }
                     exit ;
                 end ;
             end
             else begin
                 if ExtractUUEncode(nomDeSortie, repertoireDestination, fichierALire) = False
                 then begin
                     Result := False ;
                     CloseFile(fichierALire) ;                     
                     exit ;
                 end ;
             end ;

             { Lit une ligne. Normalement le end }
             ReadLn(fichierALire, ligne) ;
             ligne := LowerCase(ligne) ;

             if ligne <> 'end'
             then
                  ListeErreurs.Lines.Append('La ligne "end" n''a pas �t� d�tect�e � la fin des donn�es pour le fichier ' + nomDeSortie) ;
        end ;
    end ;

    CloseFile(fichierALire) ;
end ;

{*******************************************************************************
 * Copie les X premiers caract�res d'une chaine.
 * Si la chaine est plus courte que ce qu'on veut copier, c'est la chaine qui
 * est retourn�.
 *
 * Entr�e : chaine � copier, nombre de caract�res � copier
 * Sortie : aucune
 * Retour : la chaine voulue
 ******************************************************************************}
function TmainForm.StrCopyN(chaine : String; valMax : Integer) : String ;
Var i : Integer ;
begin
    Result := '' ;

    if (Length(chaine) >= valMax)
    then
        for i := 1 to valMax do
            Result := Result + chaine[i]
    else
        Result := chaine ;
end ;

{*******************************************************************************
 * Copie du caract�re X � la fin de la chaine.
 * Si la position est supp�rieur � la taille de la chaine, une chaine vide est
 * retourn�e.
 *
 * Entr�e : chaine � copier, position de d�but de copie
 * Sortie : aucune
 * Retour : la chaine voulue
 ******************************************************************************}
function TmainForm.StrCopyToN(chaine : String; startPos : Integer) : String ;
Var i : Integer ;
    lenChaine : Integer ;
begin
    Result := '' ;

    lenChaine := Length(chaine) ;

    if (lenChaine >= startPos)
    then
        for i := startPos to lenChaine do
            Result := Result + chaine[i]
    else
        Result := '' ;
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
function TmainForm.ExtractUUEncode(nomDeSortie : String; repertoireDestination : String; Var fichierALire : TextFile) : Boolean;
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
                 ListeErreurs.Lines.Append('Une ligne vide a �t� d�tect�e dans le flux de donn�es du fichier ' + nomDeSortie + '. Ligne ignor�e.') ;

        until ligneEnCours <> '';   { Si on rencontre une ligne vide, on l'ignore}

        ligneEnCours := Trim(ligneEncours) ;

        if (ligneEnCours <> '`')
        then begin
            longueurLigneEncours := length(ligneEnCours) ;

            { Si le premier caract�re est compris entre '!' et 'M' }
            if (Ord(ligneEnCours[1]) > $20) and (Ord(ligneEnCours[1]) < $4E)
            then begin
                { Calcule la longueur des donn�es de la ligne }
                longueurBuffer := CodeOfUUD(ligneEnCours[1]) ;

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
                    ListeErreurs.Lines.Append('La longueur indiqu� par l''indicateur de longueur de la ligne ne correspond pas � la longueur r�elle de la ligne. Ligne ignor�e.') ;
                end
                else begin
                    tailleFichier := tailleFichier + longueurBuffer ;

                    i := 2 ;
                    j := 0 ;

                    repeat
                        c1 := CodeOfUUD(ligneEncours[i]) ;
                        c2 := CodeOfUUD(ligneEncours[i + 1]) ;
                        c3 := CodeOfUUD(ligneEncours[i + 2]) ;
                        c4 := CodeOfUUD(ligneEncours[i + 3]) ;

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
                ListeErreurs.Lines.Append('Un indicateur de longueur de ligne est erron� dans le flux de donn�es du fichier ' + nomDeSortie + '. Ligne ignor�e.') ;
        end ;
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
 * Dencode un caract�re en UUE
 *
 * Entr�e : Octet � encoder
 * Sortie : aucune
 * Retour : Chaine de caract�re contenant l'octet
 ******************************************************************************}
function TmainForm.CodeOfUUD(Octet : String) : Byte ;
begin
    if (Octet  <> '`')
    then
        Result := Ord(Octet[1]) - $20  { Octet + Espace }
    else
        Result := 0 ;
end ;

procedure TmainForm.FormCreate(Sender: TObject);
begin
end;

{*******************************************************************************
 * Ignore le flux de donn�e en cours
 *
 * Entr�e : Fichier � lire
 * Sortie : aucune
 * Retour : auncun
 ******************************************************************************}
procedure TmainForm.IgnoreExctractUUEncode(Var fichierALire : TextFile) ;
Var ligneEnCours : String ;
begin
    repeat
        ReadLn(fichierALire, ligneEnCours) ;
        ligneEnCours := Trim(ligneEnCours) ;
    until ligneEnCours = '`';   { Si on rencontre une ligne vide, on l'ignore}
end ;

{*******************************************************************************
 * Affiche la fen�tre d'erreur s'il y en a
 *
 * Entr�e : aucun
 * Sortie : aucune
 * Retour : auncun
 ******************************************************************************}
procedure TmainForm.ShowErrorIfExists() ;
begin
        if ListeErreurs.Lines.Count <> 0 
        then begin
            FicheErreur := TFicheErreur.Create(Self) ;
            FicheErreur.ShowModal ;
            FicheErreur.Free ;
        end ;
end ;

end.

