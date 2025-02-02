unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, XPTheme, ComCtrls, ExtDlgs, FileCtrl, raccourci,
  Menus;

type
  TForm1 = class(TForm)
    Accueil: TPanel;
    ConfigurationGeneral: TPanel;
    apropos: TButton;
    precedent: TButton;
    suivant: TButton;
    terminer: TButton;
    Bevel1: TBevel;
    annuler: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    ListBox1: TListBox;
    AppName: TLabeledEdit;
    AppVerName: TLabeledEdit;
    DefaultDirName: TLabeledEdit;
    Password: TLabeledEdit;
    WindowVisible: TCheckBox;
    AppCopyright: TLabeledEdit;
    PrivilegesRequiredLabel: TLabel;
    PrivilegesRequired: TComboBox;
    AlwaysRestart: TCheckBox;
    Bevel2: TBevel;
    Image1: TImage;
    Bevel3: TBevel;
    Label4: TLabel;
    Compression: TPanel;
    CompressionLabel: TLabel;
    CompressionList: TComboBox;
    SolidCompression: TRadioGroup;
    Langue: TPanel;
    LangageList: TListView;
    LangageLabel: TLabel;
    ShowLanguageDialog: TRadioGroup;
    Licence: TPanel;
    LicenseFileCheck: TCheckBox;
    LicenseFile: TEdit;
    Button1: TButton;
    OpenDialog1: TOpenDialog;
    InfoBeforeFileCheck: TCheckBox;
    InfoBeforeFile: TEdit;
    Button2: TButton;
    InfoAfterFileCheck: TCheckBox;
    InfoAfterFile: TEdit;
    Button3: TButton;
    ConfigImages: TPanel;
    Label5: TLabel;
    WizardImageFileCheck: TCheckBox;
    WizardImageFile: TEdit;
    Button4: TButton;
    WizardSmallImageFileCheck: TCheckBox;
    WizardSmallImageFile: TEdit;
    Button5: TButton;
    WizardImageStretch: TCheckBox;
    OpenPictureDialog1: TOpenPictureDialog;
    Fichiers: TPanel;
    Label6: TLabel;
    FileBaseDir: TEdit;
    IncludeSubDire: TCheckBox;
    Button6: TButton;
    ListFile: TListBox;
    ScrollBox1: TScrollBox;
    Label7: TLabel;
    Button8: TButton;
    Label8: TLabel;
    Raccourcis: TPanel;
    Label9: TLabel;
    ShortCutList: TListBox;
    Button7: TButton;
    Button9: TButton;
    Final: TPanel;
    completePath: TButton;
    PopupMenu1: TPopupMenu;
    RepertoireWindows1: TMenuItem;
    Repertoiresysteme1: TMenuItem;
    Repertoiredesprogrammes1: TMenuItem;
    Repertoiredesfichierscommuns1: TMenuItem;
    RepertoireMesDocuments1: TMenuItem;
    RepertoireApplicationData1: TMenuItem;
    Label10: TLabel;
    SaveDialog1: TSaveDialog;
    procedure suivantClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure precedentClick(Sender: TObject);
    procedure WindowVisibleClick(Sender: TObject);
    procedure annulerClick(Sender: TObject);
    procedure LicenseFileCheckClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure InfoBeforeFileCheckClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure InfoAfterFileCheckClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure WizardImageFileCheckClick(Sender: TObject);
    procedure WizardSmallImageFileCheckClick(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure ListFileClick(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure completePathClick(Sender: TObject);
    procedure ChangeVarInDefaultDirNameClick(Sender: TObject);
    procedure terminerClick(Sender: TObject);
  private
    { D�clarations priv�es }
    CurrentPage : Integer ;
    ListeRaccourciFichier : TStringList ;
    ListeRaccourciParam : TStringList ;    
    procedure CacherPage ;
    procedure AfficherPage ;
    function VerificationPage : boolean;
    function CheckAccueil : boolean ;
    function CheckGeneralConfig : boolean ;
    function CheckCompression : boolean ;
    function CheckLangage : boolean ;
    function CheckLicence : boolean ;
    function CheckImage : boolean ;
    function CheckFiles : boolean ;
    function CheckShortCut : boolean ;
    procedure SetWindowCaption(Titre : String) ;
    procedure listerRepertoire(const rep : String; const repAff : String) ;
    procedure listerFichier(const rep : String; const repAff : String) ;
    procedure Progres ;
    function StrCopyToN(chaine : String; startPos : Integer) : String ;
    function StrCopyN(chaine : String; valMax : Integer) : String ;        
  public
    { D�clarations publiques }
  end;

var
  Form1: TForm1;
  troisPetitsPoints : Integer ;
  Erreur1Titre : String = 'Erreur' ;
  Erreur11Titre : String = 'Attention' ;  
  Erreur1Text : String = 'Les champs en gras sont obligatoires.' ;
  Erreur2Text : String = 'Vous devez s�lectionner une langue.' ;
  Erreur3Text : String = 'Vous devez entrer un nom de fichier � afficher apr�s l''installation.' ;
  Erreur4Text : String = 'Vous devez entrer un nom de fichier � afficher avant l''installation.' ;
  Erreur5Text : String = 'Vous devez entrer un nom de fichier de licence.' ;
  Erreur6Text : String = 'Vous devez entrer un nom de fichier contenant la grande image.' ;
  Erreur7Text : String = 'Vous devez entrer un nom de fichier contenant la petite image.' ;
  Erreur8Text : String = 'Vous devez entrer un r�pertoire.' ;
  Erreur9Text : String = 'Il n''a aucun fichiers dans la liste.' ;
  Erreur10Text : String = 'Vous devez entrer un nom de raccourci.' ;
  Erreur11Text : String = 'Vous n''avez pas cr�� de raccourci, souhaitez-vous continuer ?' ;
  Titre1 : String = 'Configuration g�n�rale' ;
  Titre2 : String = 'Param�tre de compression' ;
  Titre3 : String = 'Langue disponible' ;
  Titre4 : String = 'Licence et fichiers d''informations' ;
  Titre5 : String = 'Images' ;
  Titre6 : String = 'Fichiers' ;
  Titre7 : String = 'Raccourcis' ;
  Titre8 : String = 'Terminer' ;
  Texte1 : String = 'S�lectionnez le r�pertoire contenant les fichiers d''installation.' ;
  Texte2 : String = 'Lecture en cours' ;
  Texte3 : String = 'Nombre de fichiers : ' ;

  // Fen�tre Raccourci
  TitreRaccourci : String = 'Raccourci' ;
  BoutonOkRaccourci : String = 'Ok' ;
  CaptionFichier : String = 'Fichier' ;
  CaptionParams : String = 'Param�tres' ;

  (* SETUP
    - AppName.Text ;
    - AppVerName.Text ;
    - DefaultDirName.Text ;  -> (permettre de choisir les r�pertoire {pf}� voir capture InstallMaker
    - Password.Text
    - PrivilegesRequired.ItemIndex (0 : non, 1 : admin, 2 poweruser)
    - WindowVisible.Checked
      - AppCopyright.Text
    - AlwaysRestart.Checked
    - CompressionList.ItemIndex (0 : lzma, 1 : zip, 2 : bzip, 3 : none)
    - SolidCompression.ItemIndex  (0 : yes, 1 : no)
    - ShowLanguageDialog.ItemIndex (0 : auto, 1 : yes)
    - LicenseFileCheck.Checked
      - LicenseFile.Text
    - InfoBeforeFileCheck.Checked
      - InfoBeforeFile.Text
    - InfoAfterFileCheck.Checked
      - InfoAfterFile.Text
    - WizardSmallImageFileCheck.Checked
      - WizardSmallImageFile.Text ;
    - WizardImageFileCheck.Checked
      - WizardImageFile.Text ;
    - WizardImageStretch.Checked

    LANGUAGE
    - LangageList.Items ;

    FILES
    - ListFile.Items + FileBaseDir.Text ;

    ICONE
    - ShortCutList.Items + ListeRaccourciFichier.Strings
    -
  *)

  (*
    Fran�ais : 0
    English : 1
    Deutch : 2
    Catalan : 3
    Dutch. : 4
    Czech : 5
    Norwegian : 6
    Polish : 7
    Portuguese : 8
    Russian : 9
    Slovenian : 10
  *)

implementation

{$R *.dfm}

{*******************************************************************************
 * Fonction appel�e pour v�rifier les donn�es de la page d'accueil
 ******************************************************************************}
function TForm1.CheckAccueil : boolean ;
Var temp : String ;
begin
    Result := True ;

    if ParamCount > 0
    then begin
        temp := AnsiLowerCase(ParamStr(1)) ;

        if temp = 'english'
        then
            ListBox1.ItemIndex := 1 ;
    end ;


    case ListBox1.ItemIndex of
        // English
        1 : begin
                apropos.Caption := 'About...' ;
                precedent.Caption := '< &Previous' ;
                suivant.Caption := '&Next >' ;
                annuler.Caption := '&Cancel' ;
                terminer.Caption := '&Terminate' ;
                AppName.EditLabel.Caption := 'Application name' ;
                AppVerName.EditLabel.Caption := 'Name and version of application' ;
                DefaultDirName.EditLabel.Caption := 'Default installtion directory name' ;
                Password.EditLabel.Caption := 'Password to protect installation (not requiered)' ;
                WindowVisible.Caption := 'Create a full screen installation' ;
                PrivilegesRequired.Items.Clear ;
                PrivilegesRequired.Items.Add('None') ;
                PrivilegesRequired.Items.Add('Administrator') ;
                PrivilegesRequired.Items.Add('Power user') ;
                PrivilegesRequired.ItemIndex := 0 ;                
                PrivilegesRequiredLabel.Caption := 'Installation requiered privileges :' ;
                AlwaysRestart.Caption := 'A reboot of computer was necessary at end of installation.' ;
                Erreur1Text := 'All field in bold are requiered.' ;
                Erreur1Titre := 'Error' ;
                Titre1 := 'General configuration' ;
                Titre2 := 'Compression' ;
                CompressionList.Items.Delete(3);
                CompressionLabel.Caption := 'Use this compression :' ;
                CompressionList.Items.Add('none') ;
                SolidCompression.Items.Clear ;
                SolidCompression.Items.Add('Create one file with all files and compress it') ;
                SolidCompression.Items.Add('Compresse all files one by one and concat there in one file') ;
                SolidCompression.ItemIndex := 0 ;
                Titre3 := 'Disponible language' ;
                SolidCompression.Caption := ' Method of compression used ' ;
                Label4.Caption := 'Bold = requiered' ;
                LangageLabel.Caption := 'Check below the languages which you wish to make available to the installation :' ;
                ShowLanguageDialog.Items.Clear ;
                ShowLanguageDialog.Items.Add('Detect the language automatically') ;
                ShowLanguageDialog.Items.Add('Post limps it of dialogue of selection of language') ;
                ShowLanguageDialog.ItemIndex := 0 ;
                ShowLanguageDialog.Caption := 'Language choice' ;
                Erreur2Text := 'You must choice a language.' ;
                Titre4 := 'License and information files' ;
                LicenseFileCheck.Caption := 'Show license who is in this file' ;
                InfoBeforeFileCheck.Caption := 'Show informations that contain this file, before installation' ;
                InfoAfterFileCheck.Caption := 'Show informations that contain this file, after installation' ;
                OpenDialog1.Filter := 'Text files |*.txt|All files |*.*' ;
                Erreur3Text := 'You must enter a name of file who contain license.' ;
                Erreur4Text := 'You must enter a name of file who contain informations show before installation.' ;
                Erreur5Text := 'You must enter a name of file who contain informations show before installation.' ;
                Titre5 := 'Pictures' ;
                Erreur6Text := 'You must enter a name of file who contain the big pictures.' ;
                Erreur7Text := 'You must enter a name of file who contain the small pictures.' ;
                Label5.Caption := 'You can now, if you want, selecte pictures to modify your installation.' ;
                WizardImageFileCheck.Caption := 'Big picture' ;
                WizardSmallImageFileCheck.Caption := 'Small picture' ;
                WizardImageStretch.Caption := 'Stretch picture' ;
                Titre6 := 'Files' ;
                Texte1 := 'Select the directory who contain install files.' ;
                Texte2 := 'In progress' ;
                Label6.Caption := 'Select the directory who contain files :' ;
                IncludeSubDire.Caption := 'Include sub-directory' ;
                Texte3 := 'Files number : ' ;
                Erreur8Text := 'You muste enter a directory name.' ;
                Erreur9Text := 'No file in list.' ;
                Label9.Caption := 'Create your shortcuts.' ;
                TitreRaccourci := 'Shortcut' ;
                //BoutonOkRaccourci := 'Ok' ;
                CaptionFichier := 'File' ;
                CaptionParams := 'Parameters' ;
                Erreur11Text := 'No shurtcuts was created, do you want continue ?' ;
                Erreur11Titre := 'Caution' ;
                RepertoireWindows1.Caption := 'Windows directory' ;
                Repertoiresysteme1.Caption := 'System directory' ;
                Repertoiredesprogrammes1.Caption := 'Program files directory' ;
                Repertoiredesfichierscommuns1.Caption := 'Commun files directory' ;
                RepertoireMesDocuments1.Caption := 'My Files directory' ;
                RepertoireApplicationData1.Caption := 'Application data directory' ;
                Label10.Caption := 'The model of installation was terminate. Click on the button Terminate.' ;
                Titre7 := 'ShortCut' ;
                Titre8 := 'Terminate' ;
            end ;
        else
            ListBox1.ItemIndex := 0 ;
    end ;
end ;

{*******************************************************************************
 * Fonction appel�e pour v�rifier les donn�es de la page des images
 ******************************************************************************}
function TForm1.CheckImage : boolean ;
begin
    Result := False ;

    if WizardImageFileCheck.Checked and (WizardImageFile.Text = '')
    then
        Application.MessageBox(PChar(Erreur6Text), PChar(Erreur1Titre), MB_OK + MB_ICONERROR)
    else
        if WizardSmallImageFileCheck.Checked and (WizardSmallImageFile.Text = '')
        then
            Application.MessageBox(PChar(Erreur7Text), PChar(Erreur1Titre), MB_OK + MB_ICONERROR)
        else begin
            Result := True ;
        end ;
end ;

{*******************************************************************************
 * Fonction appel�e pour v�rifier les donn�es de la page de licence
 ******************************************************************************}
function TForm1.CheckLicence : boolean ;
begin
    Result := False ;

    if LicenseFileCheck.Checked and (LicenseFile.Text = '')
    then
        Application.MessageBox(PChar(Erreur5Text), PChar(Erreur1Titre), MB_OK + MB_ICONERROR)
    else
        if InfoBeforeFileCheck.Checked and (InfoBeforeFile.Text = '')
        then
            Application.MessageBox(PChar(Erreur4Text), PChar(Erreur1Titre), MB_OK + MB_ICONERROR)
        else
            if InfoAfterFileCheck.Checked and (InfoAfterFile.Text = '')
            then
                Application.MessageBox(PChar(Erreur3Text), PChar(Erreur1Titre), MB_OK + MB_ICONERROR)
            else begin
                Result := True ;
            end ;
end ;

{*******************************************************************************
 * Fonction appel�e pour v�rifier les donn�es de la page de langue
 ******************************************************************************}
function TForm1.CheckLangage : boolean ;
Var i : Integer ;
begin
    Result := False ;
    
    for i := 0 to LangageList.Items.Count - 1 do
        if LangageList.Items.Item[i].Checked
        then begin
            Result := True ;
            break ;
        end ;

    if Result = False
    then
        Application.MessageBox(PChar(Erreur2Text), PChar(Erreur1Titre), MB_OK + MB_ICONERROR) ;
end ;

{*******************************************************************************
 * Fonction appel�e pour v�rifier les donn�es de la page de compression
 ******************************************************************************}
function TForm1.CheckCompression : boolean ;
begin
    Result := True ;
end ;

{*******************************************************************************
 * Fonction appel�e pour v�rifier les donn�es de la page d'accueil
 ******************************************************************************}
function TForm1.CheckGeneralConfig : boolean ;
begin
    Result := False ;

    if (AppName.Text <> '') and (DefaultDirName.Text <> '') and
       (AppVerName.Text <> '')
    then begin
        Result :=  True ;
    end ;

    if Result = False
    then            
        Application.MessageBox(PChar(Erreur1Text), PChar(Erreur1Titre), MB_OK + MB_ICONERROR) ;
end ;

{*******************************************************************************
 * Proc�dure appel� quand on clique sur le bouton suivant
 ******************************************************************************}
procedure TForm1.suivantClick(Sender: TObject);
begin
    if VerificationPage
    then begin
        CacherPage ;
        CurrentPage := CurrentPage + 1 ;
        AfficherPage ;
    end ;
end;

{*******************************************************************************
 * Proc�dure appel� � la cr�ation de la fen�tre
 ******************************************************************************}
procedure TForm1.FormCreate(Sender: TObject);
type
  TIsThemeActive = function: BOOL; stdcall;
var
  IsThemeActive: TIsThemeActive;
  huxtheme: HMODULE;
begin
    // Initialise la variable
    CurrentPage := 0 ;

    ListeRaccourciFichier := TStringList.Create ;
    ListeRaccourciParam := TStringList.Create ;

    if ParamCount > 0
    then begin
        suivantClick(Sender) ;
    end ;

    Width := 639 ;
    Height := 345 ;

    // Si on ex�cute le programme sous Windows XP et que le th�me est actif, on
    // modifi la taille de la fen�tre
    huxtheme := LoadLibrary('uxtheme.dll');

    if huxtheme <> 0
    then begin
      try
        // r�cup�ration de la fonction qui permet de connaitre si le th�me XP
        // est actif
        IsThemeActive := GetProcAddress(huxtheme, 'IsThemeActive');
        // utilisation de cette fonction
        if IsThemeActive
        then
             Height := Height + 5 ;
      finally
          if huxtheme > 0
          then
              FreeLibrary(huxtheme);
      end;
    end;
end;

{*******************************************************************************
 * Proc�dure appel� pour cacher la feuille correspondant � CurrentPage
 ******************************************************************************}
procedure TForm1.CacherPage ;
begin
    case CurrentPage of
        0 : Accueil.Visible := False ;
        1 : ConfigurationGeneral.Visible := False ;
        2 : Compression.Visible := False ;
        3 : Langue.Visible := False ;
        4 : Licence.Visible := False ;
        5 : ConfigImages.Visible := False ;
        6 : Fichiers.Visible := False ;
        7 : Raccourcis.Visible := False ;
        8 : Final.Visible := False ;
    end ;
end ;

{*******************************************************************************
 * Proc�dure appel� pour cacher la feuille correspondant � CurrentPage
 ******************************************************************************}
procedure TForm1.AfficherPage ;
begin
    // D�sactive le bouton suivant si derni�re page
    if CurrentPage = 8
    then begin
        suivant.Enabled := False ;
        terminer.Enabled := True ;
        annuler.Enabled := False ;
    end
    else begin
        suivant.Enabled := True ;
        terminer.Enabled := False ;
        annuler.Enabled := True ;        
    end ;

    // D�sactive le bouton pr�c�dent si premi�re page
    if CurrentPage = 1
    then
        precedent.Enabled := False
    else
        precedent.Enabled := True ;

    case CurrentPage of
        0 : begin
                Accueil.Visible := True ;
            end ;
        1 : begin
                ConfigurationGeneral.Visible := True ;
                SetWindowCaption(Titre1) ;
            end ;
        2 : begin
                Compression.Visible := True ;
                SetWindowCaption(Titre2) ;
            end ;
        3 : begin
                Langue.Visible := True ;
                // S�lection la langue en cours.
                LangageList.Items[ListBox1.ItemIndex].Checked := True ;
                SetWindowCaption(Titre3) ;
            end ;
        4 : begin
                Licence.Visible := True ;
                SetWindowCaption(Titre4) ;
            end ;
        5 : begin
                ConfigImages.Visible := True ;
                SetWindowCaption(Titre5) ;
            end ;
        6 : begin
                Fichiers.Visible := True ;
                SetWindowCaption(Titre6) ;
            end ;
        7 : begin
                Raccourcis.Visible := True ;
                SetWindowCaption(Titre7) ;
            end ;
        8 : begin
                Final.Visible := True ;
                SetWindowCaption(Titre5) ;
            end ;
    end ;
end ;

{*******************************************************************************
 * Proc�dure appel� quand on clique sur le bouton pr�c�dent
 ******************************************************************************}
procedure TForm1.precedentClick(Sender: TObject);
begin
    CacherPage ;
    CurrentPage := CurrentPage - 1 ;
    AfficherPage ;
end;

{*******************************************************************************
 * Proc�dure pour v�rifier que les param�tres entr�s dans la page sont corrects
 ******************************************************************************}
function TForm1.VerificationPage : boolean ;
begin
    case CurrentPage of
        0 : Result := CheckAccueil ;
        1 : Result := CheckGeneralConfig ;
        2 : Result := CheckCompression ;
        3 : Result := CheckLangage ;
        4 : Result := CheckLicence ;
        5 : Result := CheckImage ;
        6 : Result := CheckFiles ;
        7 : Result := CheckShortCut ;
//
        8 : Final.Visible := True ;
    end ;
end ;

{*******************************************************************************
 * Proc�dure appeler pour activer la zone de texte du copyright de l'application
 * si install en plein �cran.
 ******************************************************************************}
procedure TForm1.WindowVisibleClick(Sender: TObject);
begin
    AppCopyright.Enabled := WindowVisible.Checked ;
end;

{*******************************************************************************
 * Proc�dure appel� quand on clique sur le bouton annul�
 ******************************************************************************}
procedure TForm1.annulerClick(Sender: TObject);
begin
    Close ;
end;

{*******************************************************************************
 * Proc�dure quand on coche l'int�gration d'une licence
 ******************************************************************************}
procedure TForm1.LicenseFileCheckClick(Sender: TObject);
begin
    LicenseFile.Enabled := LicenseFileCheck.Checked ;
    Button1.Enabled := LicenseFileCheck.Checked ;
end;

{*******************************************************************************
 * Proc�dure quand on clique sur le bouton ...
 ******************************************************************************}
procedure TForm1.Button1Click(Sender: TObject);
begin
    OpenDialog1.InitialDir := ExtractFileDir(LicenseFile.Text) ;
    OpenDialog1.FileName := ExtractFileName(LicenseFile.Text) ;

    if OpenDialog1.Execute
    then
        LicenseFile.Text := OpenDialog1.FileName ;
end;

{*******************************************************************************
 * Proc�dure quand on coche l'int�gration d'un fichier d'information avant install
 ******************************************************************************}
procedure TForm1.InfoBeforeFileCheckClick(Sender: TObject);
begin
    InfoBeforeFile.Enabled := InfoBeforeFileCheck.Checked ;
    Button2.Enabled := InfoBeforeFileCheck.Checked ;
end;

{*******************************************************************************
 * Proc�dure quand on clique sur le bouton ...
 ******************************************************************************}
procedure TForm1.Button2Click(Sender: TObject);
begin
    OpenDialog1.InitialDir := ExtractFileDir(InfoBeforeFile.Text) ;
    OpenDialog1.FileName := ExtractFileName(InfoBeforeFile.Text) ;

    if OpenDialog1.Execute
    then
        InfoBeforeFile.Text := OpenDialog1.FileName ;
end;

{*******************************************************************************
 * Proc�dure quand on coche l'int�gration d'un fichier d'information apr�s install
 ******************************************************************************}
procedure TForm1.InfoAfterFileCheckClick(Sender: TObject);
begin
    InfoAfterFile.Enabled := InfoAfterFileCheck.Checked ;
    Button3.Enabled := InfoAfterFileCheck.Checked ;
end;

{*******************************************************************************
 * Proc�dure quand on clique sur le bouton ...
 ******************************************************************************}
procedure TForm1.Button3Click(Sender: TObject);
begin
    OpenDialog1.InitialDir := ExtractFileDir(InfoAfterFile.Text) ;
    OpenDialog1.FileName := ExtractFileName(InfoAfterFile.Text) ;

    if OpenDialog1.Execute
    then
        InfoAfterFile.Text := OpenDialog1.FileName ;
end;

{*******************************************************************************
 * Proc�dure qu'on app�le pour changer le titre de la fen�tre
 ******************************************************************************}
procedure TForm1.SetWindowCaption(Titre : String) ;
begin
    Caption := 'Simple Wizard for Inno Setup > ' + Titre ;
end ;

{*******************************************************************************
 * Proc�dure quand on coche la modification du fichier d'image
 ******************************************************************************}
procedure TForm1.WizardImageFileCheckClick(Sender: TObject);
begin
    WizardImageFile.Enabled := WizardImageFileCheck.Checked ;
    Button4.Enabled := WizardImageFileCheck.Checked ;

    if WizardImageFileCheck.Checked or WizardSmallImageFileCheck.Checked
    then
        WizardImageStretch.Enabled := True
    else
        WizardImageStretch.Enabled := False ;       

end;

{*******************************************************************************
 * Proc�dure quand on coche la modification du fichier d'image
 ******************************************************************************}
procedure TForm1.WizardSmallImageFileCheckClick(Sender: TObject);
begin
    WizardSmallImageFile.Enabled := WizardSmallImageFileCheck.Checked ;
    Button5.Enabled := WizardSmallImageFileCheck.Checked ;

    if WizardImageFileCheck.Checked or WizardSmallImageFileCheck.Checked
    then
        WizardImageStretch.Enabled := True
    else
        WizardImageStretch.Enabled := False ;
end;

{*******************************************************************************
 * Proc�dure quand on clique sur le bouton ...
 ******************************************************************************}
procedure TForm1.Button4Click(Sender: TObject);
begin
    OpenPictureDialog1.InitialDir := ExtractFileDir(WizardImageFile.Text) ;
    OpenPictureDialog1.FileName := ExtractFileName(WizardImageFile.Text) ;

    if OpenPictureDialog1.Execute
    then
        WizardImageFile.Text := OpenPictureDialog1.FileName ;
end;

{*******************************************************************************
 * Proc�dure quand on clique sur le bouton ...
 ******************************************************************************}
procedure TForm1.Button5Click(Sender: TObject);
begin
    OpenPictureDialog1.InitialDir := ExtractFileDir(WizardSmallImageFile.Text) ;
    OpenPictureDialog1.FileName := ExtractFileName(WizardSmallImageFile.Text) ;

    if OpenPictureDialog1.Execute
    then
        WizardSmallImageFile.Text := OpenPictureDialog1.FileName ;
end;

{*******************************************************************************
 * Proc�dure quand on clique sur le bouton ...
 ******************************************************************************}
procedure TForm1.Button6Click(Sender: TObject);
var
  Dir: string;
begin
  troisPetitsPoints := 1 ;
  
  if   SelectDirectory(Texte1, '', Dir)
  then begin
      ListFile.Items.Clear ;
      
      if Dir[Length(Dir)] <> '\'
      then
          Dir := Dir + '\' ;

      FileBaseDir.Text := Dir ;

      // Si on inclu les sous r�pertoires
      if IncludeSubDire.Checked
      then
          listerRepertoire(Dir, '')
      else
          listerFichier(Dir, '') ;
  end ;

  Label7.Caption := '' ;
  troisPetitsPoints := 0 ;
  
  Label8.Caption := Texte3 + IntToStr(ListFile.Items.Count) ;
end;

{*******************************************************************************
 * Proc�dure pour lister un r�pertoire
 ******************************************************************************}
procedure TForm1.listerRepertoire(const rep : String; const repAff : String) ;
var
  sr: TSearchRec;
  FileAttrs: Integer;
begin
    FileAttrs := faAnyFile ; //faDirectory + faSysFile ;

    // Affiche la liste des fichiers contenu dans le r�peroire    
    listerFichier(rep, repAff) ;

    // Si on trouve une premi�re occurence
    if FindFirst(rep + '*.*', FileAttrs, sr) = 0
    then begin
        // Liste tous les r�peroires
        repeat
            if ((sr.Attr and faDirectory) > 0) and (sr.Name <> '.') and (sr.Name <> '..')
            then begin
                ListFile.Items.Add(repAff + sr.Name) ;

                Progres ;

                // G�re les messages
                Application.ProcessMessages ;

                listerRepertoire(rep + sr.Name + '\', repAff + sr.Name + '\') ;
            end ;
        until FindNext(sr) <> 0 ;

        // D�truit les ressources utilis�es
        FindClose(sr);
    end ;
end ;

{*******************************************************************************
 * Proc�dure pour lister les fichier d'un r�pertoire
 ******************************************************************************}
procedure TForm1.listerFichier(const rep : String; const repAff : String) ;
var
  sr: TSearchRec;
  FileAttrs: Integer;
begin
    FileAttrs := faAnyFile - faDirectory ;

    // Si on trouve une premi�re occurence
    if FindFirst(rep + '\*.*', FileAttrs, sr) = 0
    then begin
        // Liste tous les r�peroires
        repeat
            if (sr.Attr and FileAttrs) > 0
            then begin
                ListFile.Items.Add(repAff + sr.Name) ;
                Progres ;
                Application.ProcessMessages ;
            end ;
        until FindNext(sr) <> 0 ;

        // D�truit les ressources utilis�es
        FindClose(sr);
    end ;
end ;

{*******************************************************************************
 * Proc�dure quand on clique sur une liste de fichiers
 ******************************************************************************}
procedure TForm1.ListFileClick(Sender: TObject);
begin
    if troisPetitsPoints = 0
    then
        Label7.Caption := ListFile.Items.Strings[ListFile.ItemIndex] ;
end;

{*******************************************************************************
 * Proc�dure pour afficher la progression
 ******************************************************************************}
procedure TForm1.Progres ;
begin
     if troisPetitsPoints > 21
     then begin
         Label7.Caption := Texte2 + ' ' ;
         troisPetitsPoints := 1 ;
     end
     else begin
         troisPetitsPoints := troisPetitsPoints + 1 ;
         Label7.Caption := Label7.Caption + '.' ;
     end ;
end ;

{*******************************************************************************
 * Proc�dure pour supprimer un fichier dans la liste
 ******************************************************************************}
procedure TForm1.Button8Click(Sender: TObject);
Var
    Nb : Integer ;
    Pos : Integer ;
begin
    Nb := 0 ;

    repeat
        if ListFile.Selected[Nb]
        then begin
            // Si il y a une correspondance dans la liste des raccourcis, on
            // supprime le reccourci.
            Pos := ListeRaccourciFichier.IndexOf(ListFile.Items.Strings[nb]) ;

            if Pos > -1
            then begin
                ListeRaccourciFichier.Delete(Pos);
                ShortCutList.Items.Delete(Pos) ;
                ListeRaccourciParam.Delete(Pos);
            end ;

            ListFile.Items.Delete(Nb) ;
        end
        else
            Nb := Nb + 1 ;
    until ListFile.Items.Count = Nb ;

    Label8.Caption := Texte3 + IntToStr(ListFile.Items.Count) ;
end;

{*******************************************************************************
 * Fonction appel�e pour v�rifier les donn�es de la page de fichiers
 ******************************************************************************}
function TForm1.CheckFiles : boolean ;
begin
    Result := False ;
    
    if FileBaseDir.Text <> ''
    then
         if ListFile.Items.Count > 0
         then
             Result := True
         else
             Application.MessageBox(PChar(Erreur9Text), PChar(Erreur1Titre), MB_OK + MB_ICONERROR)
     else
         Application.MessageBox(PChar(Erreur8Text), PChar(Erreur1Titre), MB_OK + MB_ICONERROR)
end ;

{*******************************************************************************
 * Proc�dure pour supprimer un raccourci dans la liste
 ******************************************************************************}
procedure TForm1.Button9Click(Sender: TObject);
Var 
    Nb : Integer ;
begin
    Nb := 0 ;

    repeat
        if ShortCutList.Selected[Nb]
        then
            ShortCutList.Items.Delete(Nb)
        else
            Nb := Nb + 1 ;
    until ShortCutList.Items.Count = Nb ;
end;

{*******************************************************************************
 * Proc�dure pour ajouter dans la liste
 ******************************************************************************}
procedure TForm1.Button7Click(Sender: TObject);
Var ShortCutForm : TShortCutForm ;
begin
    ShortCutForm := TShortCutForm.Create(Self) ;

    if ShortCutForm.ShowModal = mrOk
    then begin
        ShortCutList.Items.Add(ShortCutForm.ShortCutName.Text) ;
        ListeRaccourciFichier.Add(ShortCutForm.ComboBox1.Text) ;
        ListeRaccourciParam.Add(ShortCutForm.Params.Text) ;
    end ;

    ShortCutForm.Free ;
end;

{*******************************************************************************
 * Proc�dure appel� quand on clique sur le bouton suivant
 ******************************************************************************}
function TForm1.CheckShortCut : boolean ;
begin
    if ShortCutList.Items.Count > 0
    then
        Result := True
    else
        if Application.MessageBox(PChar(Erreur11Text), PChar(Erreur11Titre), MB_YESNO + MB_ICONWARNING) = IDYES
        then
            Result := True
        else
            Result := False ;
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
function TForm1.StrCopyN(chaine : String; valMax : Integer) : String ;
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
function TForm1.StrCopyToN(chaine : String; startPos : Integer) : String ;
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
 * Proc�dure appel� pour afficher le menu surgissant
 ******************************************************************************}
procedure TForm1.completePathClick(Sender: TObject);
Var Point : TPoint ;
begin
     Point.X := 0;
     Point.Y := 0 ;

     Point := completePath.ClientToScreen(Point) ;

     PopupMenu1.Popup(Point.X + completePath.Width + 1,
                      Point.Y);
end;

{*******************************************************************************
 * Proc�dure appel� pour remplacer {...
 ******************************************************************************}
procedure TForm1.ChangeVarInDefaultDirNameClick(Sender: TObject);
Var chaine : String ;
    temp   : String ;
begin
    case TMenuItem(Sender).Tag of
        1 : chaine := '{sys}' ;
        2 : chaine := '{pf}' ;
        3 : chaine := '{cf}' ;
        4 : chaine := '{userdocs}' ;
        5 : chaine := '{userappdata}' ;
    else
        chaine := '{win}' ;
    end ;

    // Copie le d�but de la chaine jusqu'� {
    temp := StrCopyN(DefaultDirName.Text, Pos('{', DefaultDirName.Text) - 1) ;
    // Ajoute ce qu'on � choisi
    temp := temp + chaine ;
    // Recopie la chaine de } � la fin
    temp := temp + StrCopyToN(DefaultDirName.Text, Pos('}', DefaultDirName.Text) + 1) ;

    // Remplace le texte
    DefaultDirName.Text := temp ;
end;

{*******************************************************************************
 * Proc�dure appel� quand on clique sur le bouton Terminer
 ******************************************************************************}
procedure TForm1.terminerClick(Sender: TObject);
Var F: TextFile;
    tmp : String ;
begin
    if SaveDialog1.Execute
    then begin
        if LowerCase(ExtractFileExt(SaveDialog1.FileName)) <> '.iss'
        then
            SaveDialog1.FileName := SaveDialog1.FileName + '.iss' ;
            
        // Fichier s�lectionn� dans la bo�te de dialogue
        AssignFile(F, SaveDialog1.FileName) ;
        FileMode := 0 ;
        Rewrite(F);

        WriteLn(F, '; -- ' + ExtractFileName(SaveDialog1.FileName) + ' --') ;
        WriteLn(F , '; Generated by Simple Wizard for Inno Setup') ;
        WriteLn(F , '; SEE THE DOCUMENTATION FOR DETAILS ON CREATING .ISS SCRIPT FILES!') ;
        WriteLn(F, '') ;
        WriteLn(F, '[Setup]') ;
        WriteLn(F, 'AppName="' + AppName.Text + '"') ;
        WriteLn(F, 'AppVerName="' + AppVerName.Text + '"') ;
        WriteLn(F, 'UninstallDisplayIcon={uninstallexe}') ;
        WriteLn(F, 'DefaultDirName="' + DefaultDirName.Text + '"') ;

        if Password.Text <> ''
        then
            WriteLn(F, 'Password="' + Password.Text + '"') ;

        case PrivilegesRequired.ItemIndex of
            0 : tmp := 'none' ;
            1 : tmp := 'admin' ;
            2 : tmp := 'poweruser' ;
        end ;

        WriteLn(F, 'PrivilegesRequired=' + tmp) ;

        if WindowVisible.Checked
        then begin
            WriteLn(F, 'WindowVisible=yes') ;
            WriteLn(F, 'AppCopyright="' + AppCopyright.Text + '"') ;
        end ;

        if AlwaysRestart.Checked
        then
            WriteLn(F, 'AlwaysRestart=yes') ;

        case CompressionList.ItemIndex of
            0 : tmp := 'lzma' ;
            1 : tmp := 'zip' ;
            2 : tmp := 'bzip' ;
            3 : tmp := 'none' ;
        end ;

        WriteLn(F, 'CompressionList=' + tmp) ;

        case SolidCompression.ItemIndex of
            0 : tmp := 'yes' ;
            1 : tmp := 'no' ;
        end ;

        WriteLn(F, 'SolidCompression=' + tmp) ;

        CloseFile(F);
    end ;

end;
  (* SETUP
    - AppName.Text ;
    - AppVerName.Text ;
    - DefaultDirName.Text ;  -> (permettre de choisir les r�pertoire {pf}� voir capture InstallMaker
    - Password.Text
    - PrivilegesRequired.ItemIndex (0 : non, 1 : admin, 2 poweruser)
    - WindowVisible.Checked
      - AppCopyright.Text
    - AlwaysRestart.Checked
    - CompressionList.ItemIndex (0 : lzma, 1 : zip, 2 : bzip, 3 : none)
    - SolidCompression.ItemIndex  (0 : yes, 1 : no)
    
    - ShowLanguageDialog.ItemIndex (0 : auto, 1 : yes)
    - LicenseFileCheck.Checked
      - LicenseFile.Text
    - InfoBeforeFileCheck.Checked
      - InfoBeforeFile.Text
    - InfoAfterFileCheck.Checked
      - InfoAfterFile.Text
    - WizardSmallImageFileCheck.Checked
      - WizardSmallImageFile.Text ;
    - WizardImageFileCheck.Checked
      - WizardImageFile.Text ;
    - WizardImageStretch.Checked

    LANGUAGE
    - LangageList.Items ;

    FILES
    - ListFile.Items + FileBaseDir.Text ;

    ICONE
    - ShortCutList.Items + ListeRaccourciFichier.Strings
    -
  *)
end.
