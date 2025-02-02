// Portion code Copyright 1999 by efg (Disk Space Kludge)
// Portion code Copyright by Fabrice Deville (TExplorerButton)
// Portion code Copyright 2002 by Jose Maria Ferri (TWinButton)


// A faire
// Possibilit� de ne pas avoir de Md5
// Param�trage de la taille des volumes
// v�rifier que les fichirs de sortie n'existe pas
// mettre des process messages dans la boucle de ficheir
// mettre la progression de la bage local (il y a d�j� un pocess message denans) et g�n�rale

unit main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Md5, ComCtrls, XPTheme, ImgList, WinButton, FileCtrl ;

type
    Entete = record
      { Identificateur }
      Id             : array[0..2] of char ;
      { version du fichier }
      Version        : byte ; 
      { Ann�e de cr�ation de l'archive }
      Year           : array[0..3] of char ;
      { Mois de cr�ation de l'archive }
      Month          : array[0..1] of char ;
      { Jour de cr�ation de l'archive }
      Day            : array[0..1] of char ;
      { Heure de cr�ation de l'archive }
      Hour           : array[0..1] of char ;
      { Minute de cr�ation de l'archive }
      Minute         : array[0..1] of char ;
      { Taille du fichier }
      LengthOfFile   : Int64 ;
      { Md5 du fichier }
      Md5OfFile      : MD5Digest ;
      { Nombre de volume }
      NumberOfVolume : Cardinal ;
      { Taille du volume en cours }
      LengthOfVolume : Cardinal ;
      { Num�ro du volume }
      VolumeNumber   : Cardinal ;
    end ;

    PEntete = ^Entete ;
    PString = ^String ;

  TForm1 = class(TForm)
    OpenDialog1: TOpenDialog;
    LabelProgressionTotale: TLabel;
    LabelActionEnCours: TLabel;
    ProgressBarTotale: TProgressBar;
    ProgressBarEnCours: TProgressBar;
    ImageList1: TImageList;
    procedure FormCreate(Sender: TObject);
  private
    { D�clarations priv�es}
    BouttonCouper : TWinButton ;
    procedure Separer(LeFichier : String; TailleArchive : Cardinal; FichierDeSortie : String) ;
    procedure InitialiserEnteteFichier(EnteteF : PEntete; Fichier : PString) ;
    function NewGetDiskFreeSpace(Directory:  pChar; var FreeAvailable : Comp) : boolean ;
    procedure BouttonCouperClick(Sender: TObject);
    procedure MiseAjourBarreAction(pos : Integer) ;
  public
    { D�clarations publiques}
  end;

var
  Form1 : TForm1;
  EnteteFichier : Entete ;

implementation

{$R *.DFM}

procedure TForm1.MiseAjourBarreAction(pos : Integer);
begin
    ProgressBarEnCours.Position := pos ;
    ProgressBarEnCours.Refresh ;
    Application.ProcessMessages ;
end ;

{*******************************************************************************
 * Fonction qui coupe le fichier
 ******************************************************************************}
procedure TForm1.Separer(LeFichier : String; TailleArchive : Cardinal; FichierDeSortie : String) ;
Var
    FichierSortie : File of byte ; // Fichier en sortie
    FichierALire  : File of byte ; // Fichier � lire
    FreeSpaceDisk : comp ;         // espace libre sur le disque destination
    Stop          : boolean ;
    temp          : string ;
    i, BlockCount : integer ;
    Buffer        : array[0..511] of byte ;
    TailleVolume  : Cardinal ;
    BlockLu     : integer ;
begin
    { Affiche }
    LabelActionEnCours.Caption := 'Pr�paration des fichiers ...' ;
    LabelActionEnCours.Refresh ;

    { Initialise l'ent�te � 0 }
    FillChar(EnteteFichier, SizeOf(EnteteFichier), 0) ;

    { Initialisation l'ent�te }
    InitialiserEnteteFichier(@EnteteFichier, @LeFichier) ;

    { On d�duit de la taille de l'archive la taille de l'entete et le MD5 en fin de fichier }
    EnteteFichier.LengthOfVolume := TailleArchive ;
    TailleArchive := TailleArchive - SizeOf(EnteteFichier) - SizeOf(MD5Digest);

    { Calcule le nombre de volume }
    if (EnteteFichier.LengthOfFile mod TailleArchive) > 0
    then
        EnteteFichier.NumberOfVolume := 1 ;

    EnteteFichier.NumberOfVolume := EnteteFichier.NumberOfVolume + (EnteteFichier.LengthOfFile div TailleArchive) ;

    MiseAjourBarreAction(66) ;

    { Indique s'il faut annuler l'op�ration }
    Stop := False ;

    { On v�rifie l'espace disponible }
    if NewGetDiskFreeSpace(PChar(ExtractFileDrive(FichierDeSortie)), FreeSpaceDisk)
    then
         if CompToDouble(FreeSpaceDisk) < (EnteteFichier.LengthOfFile + (EnteteFichier.NumberOfVolume * (SizeOf(EnteteFichier) + SizeOf(MD5Digest))))
         then
             if Application.MessageBox('L''espace disque n''est pas suffisant pour d�couper l''archive. Voulez-vous continuer ?', 'Espace disque insuffusant', MB_YESNO + MB_ICONWARNING) = ID_NO
             then
                 Stop := True ;

    MiseAjourBarreAction(100) ;
                 
    if Stop <> True
    then begin
// Appeler la fonction qui d�coupe le fichier plut�t que de le faire ici    
        { Ouverture du fichier }
        FileMode := 0 ;
        AssignFile(FichierALire, LeFichier) ;
        Reset(FichierALire) ;

        { Initialise la barre de progression }
        ProgressBarTotale.Max := EnteteFichier.NumberOfVolume ;

        { Passe en �criture seule }
        FileMode := 1 ;

        For i := 1 to EnteteFichier.NumberOfVolume do
        begin
            { Met � jour le num�ro du volume }
            EnteteFichier.VolumeNumber := i ;

            { Affiche }
            LabelActionEnCours.Caption := 'Pr�paration du volume ' + IntToStr(i) + ' sur ' + IntToStr(EnteteFichier.NumberOfVolume) ;
            LabelActionEnCours.Refresh ;

            { Cr�er le nom du fichier }
            temp := FichierDeSortie + '.' + IntToStr(i) + '.dec' ;

            AssignFile(FichierSortie, temp) ;
            Rewrite(FichierSortie) ;

            { Enregistre l'ent�te }
            BlockWrite(FichierSortie, EnteteFichier, SizeOf(EnteteFichier)) ;

            { Indique la taille � copier }
            if i <> EnteteFichier.NumberOfVolume
            then
                TailleVolume := TailleArchive
            else
                TailleVolume := EnteteFichier.LengthOfFile - (TailleArchive * (EnteteFichier.NumberOfVolume - 1)) ;

            BlockLu := 0 ;

            repeat
                { On d�cr�ment ce qu'on copie }
                TailleVolume := TailleVolume - BlockLu ;

                { s'il restre plus de 512 octets � copier }
                if TailleVolume > 512
                then
                    BlockLu := 512
                else
                    BlockLu := TailleVolume ;

                BlockRead(FichierALire, Buffer, BlockLu, BlockCount) ;
                BlockWrite(FichierSortie, Buffer, BlockCount) ;
            until TailleVolume < 512 ;

            CloseFile(FichierSortie) ;
        end ;


        CloseFile(FichierALire) ;
    end ;
end ;

{*******************************************************************************
 * Initialise les champs Id, Version, Year, Month, Day, Hour, Minutes,
 * LengthOfFile, Md5OfFile.
 ******************************************************************************}
procedure TForm1.InitialiserEnteteFichier(EnteteF : PEntete; Fichier : PString) ;
Var temp : String ;
    F    : File of byte ;
begin
    { Entete }
    EnteteF^.Id[0] := 'D' ;
    EnteteF^.Id[1] := 'E' ;
    EnteteF^.Id[2] := 'C' ;

    { Version }
    EnteteF^.Version := 1 ;

    { Date }
    temp := DateToStr(Now) ;
    EnteteF^.Day[0] := temp[1] ;
    EnteteF^.Day[1] := temp[2] ;

    EnteteF^.Month[0] := temp[4] ;
    EnteteF^.Month[1] := temp[5] ;

    EnteteF^.Year[0] := temp[7] ;
    EnteteF^.Year[1] := temp[8] ;
    EnteteF^.Year[2] := temp[9] ;
    EnteteF^.Year[3] := temp[10] ;

    { Heure }
    temp := TimeToStr(Now) ;
    EnteteF^.Hour[0] := temp[1] ;
    EnteteF^.Hour[1] := temp[2] ;

    { Minute }
    temp := TimeToStr(Now) ;
    EnteteF^.Minute[0] := temp[4] ;
    EnteteF^.Minute[1] := temp[5] ;

    { Taille du fichier }
    FileMode := 0 ;
    AssignFile(F, Fichier^) ;
    Reset(F) ;
    EnteteF^.LengthOfFile := FileSize(F) ;
    CloseFile(F) ;

    { Avance la barre de d�filement }
    MiseAjourBarreAction(33) ;

    { MD5 }
    EnteteF^.Md5OfFile := MD5File(Fichier^) ;
end ;

{*******************************************************************************
 * Fonction retournant la place disponible d'un disque
 * Inspir� de Disk Space Kludge
 ******************************************************************************}
function TForm1.NewGetDiskFreeSpace(Directory:  pChar; var FreeAvailable : Comp) : boolean ;
var
    BytesPerSector   :  DWORD;
    Dir              :  pChar;
    FreeClusters     :  DWORD;
    SectorsPerCluster:  DWORD;
    Temp             :  Comp ;
    TotalClusters    :  DWORD;
begin
    if Directory <> nil
    then
        Dir := Directory
    else
        Dir := nil ;

    result := GetDiskFreeSpace(Dir, SectorsPerCluster, BytesPerSector, FreeClusters, TotalClusters) ;
    
    Temp := SectorsPerCluster * BytesPerSector ;
    FreeAvailable := Temp * FreeClusters ;
end ;

{*******************************************************************************
 * Fonction appeler quand bouton couper cliqu�
 ******************************************************************************}
procedure TForm1.BouttonCouperClick(Sender: TObject);
Var S : String ;
begin
    { Ouvre la boite de dialogue }
    if OpenDialog1.Execute
    then
        if SelectDirectory('S�lectionnez un r�pertoire ou un lecteur, o� les volumes seront cr��s.', '', S)
        then begin
            { V�rifie que le nom du r�pertoire termine par \}
            if S[length(S)] <> '\'
            then
                S := S + '\' ;
                
            Separer(OpenDialog1.FileName, 1000, S + ExtractFileName(OpenDialog1.FileName)) ;
        end ;
end;

{*******************************************************************************
 * Cr�ation de la feuille
 ******************************************************************************}
procedure TForm1.FormCreate(Sender: TObject);
begin
    BouttonCouper := TWinButton.Create(Self);
    BouttonCouper.Top := 0 ;
    BouttonCouper.Left := 0 ;
    BouttonCouper.Width := 70 ;
    BouttonCouper.Height := 70 ;
    BouttonCouper.Parent := Self ;
    BouttonCouper.Caption := 'Couper' ;
    ImageList1.GetBitmap(0, BouttonCouper.Bitmap) ;
    BouttonCouper.BitmapLayout := wbBitmapTop ;
    BouttonCouper.OnClick := BouttonCouperClick ;
end;

end.
