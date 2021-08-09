{*******************************************************************************
 * Unit� : ajouter
 *
 * Ajouter un ou des fichiers � une archive existante ou non.
 ******************************************************************************}
unit ajouter;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, attendre;

type
  TajouterFichiers = class(TForm)
    Annuler: TButton;
    Suspendre: TButton;
    Reduire: TButton;
    Label1: TLabel;
    fichierEnCours: TLabel;
    ProgressBar1: TProgressBar;
    StartEncode: TTimer;
    procedure AnnulerClick(Sender: TObject);
    procedure ReduireClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure SuspendreClick(Sender: TObject);
    procedure StartEncodeTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { D�clarations priv�es}
    { Indique si l'on doit quitter la fen�tre }
    toClose : Boolean ;
    { Nombre de fichier � mettre dans l'archive }
    NbFile : Integer ;
    { Num�ro du fichier en cours }
    NumFile : Integer ;
    function UUEncodeFile(nomFichierAEncoder : String; nomFichierDestination : String; AppendVar : Boolean) : Boolean;
    function CutString(texte : String) : String ;
  public
    { D�clarations publiques}
    AppendModeFile : Boolean ;    
  end;

var
  ajouterFichiers: TajouterFichiers;

implementation

uses main ;

{$R *.DFM}

procedure TajouterFichiers.AnnulerClick(Sender: TObject);
begin
    toClose := True ;
end;

procedure TajouterFichiers.ReduireClick(Sender: TObject);
begin
    { R�duit toute les fen�tres }
    Form1.WindowState := wsMinimized ;
    WindowState := wsMinimized ;
end;

procedure TajouterFichiers.FormResize(Sender: TObject);
begin
    { R�affiche toute les fen�tres }
    Form1.WindowState := wsNormal ;
    WindowState := wsNormal ;
end;

procedure TajouterFichiers.SuspendreClick(Sender: TObject);
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

    Visible := False ;

    attendre.ShowModal ;
    attendre.Free ;
    
    Visible := True ;
end;

procedure TajouterFichiers.StartEncodeTimer(Sender: TObject);
Var i : Integer ;
begin
    StartEncode.Enabled := False ;

    NbFile := Form1.OpenDialog1.Files.Count ;
    NumFile := 1 ;

    For i := 0 to NbFile - 1 do
    Begin
        fichierEnCours.Caption := CutString(ExtractFileName(Form1.OpenDialog1.Files.Strings[i])) + ' (' + IntToStr(NumFile) + '/' + IntToStr(NbFile) + ')' ;

        ProgressBar1.Position := NumFile * 100 div NbFile ;

        UpdateWindow(Self.Handle) ;

        if (FileExists(Form1.OpenDialog1.Files.Strings[i]))
        then begin
            UUEncodeFile(Form1.OpenDialog1.Files.Strings[i], Form1.NomArchive, AppendModeFile) ;

            if toClose = True
            then
                Close() ;

            AppendModeFile := True ;
        end
        else
           Form1.ListeErreurs.Lines.Append('Le fichier ' + Form1.OpenDialog1.Files.Strings[i] + ' est introuvable !') ;

        NumFile := NumFile + 1 ;
    End ;

    Close() ;
end;

{*******************************************************************************
 * Lit un fichier et l'encode en l'enregstrant dans un autres fichiers.
 *
 * Entr�e : nom du fichier � encoder, nom du fichier destination
 * Sortie : aucune
 * Retour : True si aucune erreur, False sinon
 ******************************************************************************}
function TajouterFichiers.UUEncodeFile(nomFichierAEncoder : String; nomFichierDestination : String;  AppendVar : Boolean) : Boolean ;
Var NbDeCarLu : Integer ;
    Buffer : Array[0..44] of Byte ;
    ChaineEncodee : String[64] ;
    i : Integer ;
    c1, c2, c3 : Byte ;
    FichierALire : File ;
    FichierAEcrire : TextFile ;
    ListItem: TListItem;
begin
    Result := True ;

    { Ouvre le fichier � lire }
    AssignFile(FichierALire, nomFichierAEncoder) ;
    { Acc�s au fichier en lecture seule }
    FileMode := 0 ;
    Reset(FichierALire, 1) ;

    { Ajoute le fichier dans la liste de la feuille principale }
    ListItem := Form1.ListView1.Items.Add ;
    ListItem.Caption := ExtractFileName(nomFichierAEncoder) ;
    ListItem.SubItems.Add(Form1.FormatSize(FileSize(FichierALire)));

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

            ChaineEncodee := ChaineEncodee + form1.CodeOfUUE(c1 shr 2) + Form1.CodeOfUUE(((c1 and 3) shl 4) or ((c2 shr 4) and 15)) + Form1.CodeOfUUE(((c2 shl 2) and 60) or ((c3 shr 6) and 3)) + Form1.CodeOfUUE(c3 and 63);

            { Saute aux trois prochains caract�res }
            i := i + 3 ;
        until (i >= NbDeCarLu) ; { On encode tant qu'on n'a pas tout encod� }

        { Ecrit la chaine encod�e }
        WriteLn(FichierAEcrire, ChaineEncodee) ;

        Application.ProcessMessages ;

        { Si on doit quitter la fen�tre }
        if toClose = True
        then begin
            {Ferme les fichiers }
            CloseFile(FichierALire) ;
            CloseFile(FichierAEcrire) ;
            Exit ;
        end ;


    until (NbDeCarLu < 45) ; { S'il  a moins de 45 caract�res, c'est qu'on est � la fin du fichier }

    { Ecrit le pied de page }
    WriteLn(FichierAEcrire, '`') ;
    WriteLn(FichierAEcrire, 'end') ;

    {Ferme les fichiers }
    CloseFile(FichierALire) ;
    CloseFile(FichierAEcrire) ;
end ;

{*******************************************************************************
 * Coupe le nom du fichier pour l'affichage
 *
 * Entr�e : texte contenant le nom du fichier
 * Sortie : auncune
 * Retour : le texte qu'il faut afficher
 ******************************************************************************}
function TajouterFichiers.CutString(texte : String) : String ;
Var i : Integer ;
    longueurChaine : Integer ;
begin
    Result := '' ;
    longueurChaine := length(texte) ;

    if longueurChaine > 43
    then begin
        { On coupe le texte }
        { On copie le 16 premier caract�res }
        For i := 1 to 19 do
            Result := Result + Texte[i] ;

        { le ... }
        Result := Result + ' ... ' ;

        { On copie le 16 premier caract�res }
        For i := (longueurChaine - 19) to longueurChaine do
            Result := Result + Texte[i] ;
    end
    else
        Result := Texte ;

end ;

procedure TajouterFichiers.FormCreate(Sender: TObject);
begin
    toClose := False ;
end;

end.
