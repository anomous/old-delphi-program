unit essai;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ImgList;

type
  TForm1 = class(TForm)
    ListView1: TListView;
    ImageList1: TImageList;
    procedure FormCreate(Sender: TObject);
    procedure ListView1ColumnClick(Sender: TObject; Column: TListColumn);

  private
    { D�clarations priv�es }
  public
    { D�clarations publiques }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
const
  Names: array[0..5, 0..1] of ShortString = (
    ('B', 'Barney'),
    ('D', 'Johnson'),
    ('A', 'HiHo'),
    ('C', 'Bugs'),
    ('F', 'Bart'),
    ('E', 'Rockey')
    );

var
  I: integer;
  NewColumn: TListColumn;
  ListItem: TListItem;
begin


  with ListView1 do
  begin
    NewColumn := Columns.Add;
    NewColumn.Caption := 'Last';
    NewColumn := Columns.Add;
    NewColumn.Caption := 'First';
    NewColumn := Columns.Add;
    NewColumn.Caption := 'First';

    for I := 0 to High(Names) do
    begin
      ListItem := Items.Add;
      ListItem.Caption := Names[I][0];
      ListItem.SubItems.Add(Names[I][1]);
      ListItem.SubItems.Add(IntToStr(I) + ' ' + IntToStr(I - 1));
      ListItem.ImageIndex := I ;
    end;
  end;
end ;

procedure TForm1.ListView1ColumnClick(Sender: TObject;
  Column: TListColumn);
Const Colonne : Integer = -1 ;           { Colone de la derni�re fois }
      OrdreCroissant : Boolean = True ; { Odre croissant }
var i, j, k, NumSubItem : Integer ;
    temp : TListItems ;
    ListItem: TListItem;
    NewListView : TListView ;
    Found : Boolean ;
    Condition : Boolean ;

    { Recopie tous les sous-items et leurs propri�t�s }
    procedure CopieSubItem(Sender : TListView; ListItem: TListItem; i : Integer; k : Integer) ;
    begin
        { Copie les sous items }
        For k := 0 to Sender.Items.Item[i].SubItems.Count - 1 do
        begin
            with Sender.Items.Item[i] do
            begin
                { Copie tout les �lements de configurations }
                ListItem.SubItems.Add(SubItems[k]);

                if NewListView.Checkboxes
                then
                    ListItem.Checked := Checked ;

                ListItem.Cut := Cut ;
                ListItem.Data := Data ;
                ListItem.DropTarget := DropTarget ;
                ListItem.Focused := Focused ;
                ListItem.ImageIndex := ImageIndex ;
                ListItem.Indent := Indent ;
                ListItem.Left := Left ;
                ListItem.OverlayIndex := OverlayIndex ;
                ListItem.Selected := Selected ;
                ListItem.StateIndex := StateIndex ;
                ListItem.Top := Top ;
            end ;
        end ;
    end ;
begin
{
    ListItem
            -> Items (TListItems)
                    -> Item[...] (TListItem)
                                -> Caption  (String)
                                -> SubItems (TStrings)
                                           -> Count
                                           -> Strings[...] (String)
                    -> Insert
                    -> Delete
}

    { Si on clique sur la m�me colone, on inverse l'ordre }
    if Colonne = Column.ID
    then
        OrdreCroissant := not OrdreCroissant
    else
        OrdreCroissant := True ;

    { M�morise la colone }
    Colonne := Column.ID ;

    { Cr�er une liste view }
    NewListView := TListView.Create(Self) ;
    NewListView.Visible := False ;

    { L'affecte � la feuille courante }
    NewListView.Parent := Self;
    { On m�morise s'il y a les case � cocher car lors de la recopie elles
      apparaissent sans qu'on leur demande quelque chose }
    NewListView.Checkboxes := (Sender as TListView).Checkboxes ;

    { Cr�er une liste }
    temp := TListItems.Create(NewListView) ;

    {** On trie la premi�re colone **}
    if Column.ID = 0
    then begin
        { Pour chaque �lement de la liste qu'on doit trier }
        For i := 0 to (Sender as TListView).Items.Count - 1 do
        begin
            { Indique qu'on n'a pas trouver de position pour l'occurence en
              cours }
            Found := False ;

            { On la trie par rapport � la nouvelle liste }
            For j := 0 to temp.Count -1 do
            begin
                {** Si l'�l�ment se situe avant **}

                { Ci-dessous la condition quand on est en ordre croissant }
                Condition := (Sender as TListView).Items.Item[i].Caption < temp.Item[j].Caption ;

                { Si on veut l'ordre d�croissant, on inverse la condition }
                if OrdreCroissant = False
                then
                    Condition := not Condition ;

                if Condition
                then begin
                    { Copie l'item principale }
                    ListItem := temp.Insert(j) ;
                    ListItem.Caption := (Sender as TListView).Items.Item[i].Caption ;

                    CopieSubItem((Sender as TListView), ListItem, i, k) ;

                    Found := True ;
                    { On sort de la boucle pour ne pas r�p�ter l'�l�ment }
                    Break ;
                end ;
            end ;

            if Found = False
            { Sinon on le copie apr�s }
            then begin
                { Copie l'item principale }
                ListItem := temp.Add ;
                ListItem.Caption := (Sender as TListView).Items.Item[i].Caption ;

                CopieSubItem((Sender as TListView), ListItem, i, k) ;
            end ;
        end ;
    end
    else begin
       { M�morise la colone dans une variable �vitant ainsi de recalculer a
         chaque fois et gagnant donc du temps en ex�cution }
        NumSubItem := Column.ID - 1 ;

        { Pour chaque �lement de la liste qu'on doit trier }
        For i := 0 to (Sender as TListView).Items.Count - 1 do
        begin
            { Indique qu'on n'a pas trouver de position pour l'occurence en
              cours }
            Found := False ;

            { On la trie par rapport � la nouvelle liste }
            For j := 0 to temp.Count -1 do
            begin
                {** Si l'�l�ment se situe avant **}
                { Ci-dessous la condition quand on est en ordre croissant }
                Condition := (Sender as TListView).Items.Item[i].SubItems.Strings[NumSubItem] < temp.Item[j].SubItems.Strings[NumSubItem] ;

                { Si on veut l'ordre d�croissant, on inverse la condition }
                if OrdreCroissant = False
                then
                    Condition := not Condition ;

                if Condition
                then begin
                    { Copie l'item principale }
                    ListItem := temp.Insert(j) ;
                    ListItem.Caption := (Sender as TListView).Items.Item[i].Caption ;

                    CopieSubItem((Sender as TListView), ListItem, i, k) ;

                    Found := True ;
                    { On sort de la boucle pour ne pas r�p�ter l'�l�ment }
                    Break ;
                end ;
            end ;

            if Found = False
            { Sinon on le copie apr�s }
            then begin
                { Copie l'item principale }
                ListItem := temp.Add ;
                ListItem.Caption := (Sender as TListView).Items.Item[i].Caption ;

                CopieSubItem((Sender as TListView), ListItem, i, k) ;
            end ;
        end ;
    end ;

    (Sender as TListView).Items.BeginUpdate ;

    (Sender as TListView).Items := NewListView.Items ;
    (Sender as TListView).Checkboxes := NewListView.Checkboxes ;

    (Sender as TListView).Items.EndUpdate ;
end;

end.
