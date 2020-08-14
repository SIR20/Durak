unit GameClasses;

interface

uses WPFObjects, MouseEventsWPF;

{
  Замечания и предложения:

  ToDo:Изменить класс карты,графические примитывы только 
  ToDo:Сделать две надписи один перевернутый, другой нормальный,на противополженных сторонах
  ToDo:***Проверка на то,можно ли покрыть этой картой другую сделать индексами массива,если индекс прокрываемй карты меньше,то покрыть можно
  ToDo:Добавить в класс Player свойство ход,т.е. может ли игрок ходить сейчас
  ToDo:Сделать проверку,кто будет ходить первым
}


type
  CProp = static class
    static  Mast := new string[4]('Черви', 'Крести', 'Буби', 'Пики');
    static Name := new string[9]('6', '7', '8', '9', '10', 'В', 'Д', 'К', 'Т');
  end;
  
  Card = class
  private
    ///Прямоугольник = карта
    rec: RectangleWPF;
    ///Графическая масть(Буби,пики и т.д.)
    cpic: PictureWPF;
    ///Имя карты(namet)(для отображения на прямоугольнике)
    cname, cnamer: TextWPF;
    ///Масть карты (Буби,пики и т.д.)
    cma: string;
    ///Имя карты(Валет,десятка и т.д.)
    cnamet: string;
    ///Цвета прямоугольника и его граней соответсвенно
    cl, bcl: GColor;
    x, y, w, h: real;
    ///True - если карта козырная
    k: boolean;
    ///Видимость реквизитов карты
    vis: boolean;
    ///Видимость карты
    cvis: boolean;
    ///Список объектов у карты
    OList := new List<ObjectWPF>;
    ///Клик по карте
    event Click: procedure;
  
  public
    constructor(x, y: real; n: string; m: string);
    begin
      (w, h) := (70, 100);
      (cnamet, cma) := (n, m);
      (cl, bcl) := (colors.Green, colors.Blue);
      (self.x, self.y) := (x, y);
      ReDraw(()->begin
        rec := new RectangleWPF(x, y, w, h, cl, 1, bcl);
        var px := (rec.Left + Round(rec.Width / 2) - 10);
        var py := (rec.Top + Round(rec.Height / 2) - 13);
        cpic := new PictureWPF(px, py, 25, 25, $'{cma}.png');
        cpic.Visible := cvis;
        cname := new TextWPF(rec.Left + 5, rec.Top + 5, cnamet, Colors.Aqua);
        cname.Visible := false;
        var tx := rec.Left + rec.Width;
        var ty := rec.Top + rec.Height;
        // var cnamer := new TextWPF(tx - 20, ty, cnamet, Colors.Aqua);
        //cnamer.Top:=ty-cnamer.Height-5;
        //cnamer.RotateAngle:=180;
      end);
      OList.Add(cpic);
      OList.Add(cname);
      var oe := new OEvents(rec, cname);
      oe.InitMouseDown;
      oe.MouseDown += o -> begin
        if Click <> nil then
          Click;
      end;
      
      var e := new Events(cpic);
      e.InitMouseDown;
      e.MouseDown += o -> begin
        if Click <> nil then
          Click;
      end;
    end;
    
    procedure AnimeTo(a, b, sec: real);
    begin
      ReDraw(()->begin
        rec.AnimMoveOn(a, b, sec);
        cpic.AnimMoveOn(a, b, sec);
        cname.AnimMoveOn(a, b, sec);
      end);
    end;
    
    procedure ToBack;
    begin
      cpic.ToBack;
      cname.ToBack;
      rec.ToBack;
    end;
    
    procedure ToFront;
    begin
      rec.ToFront;
      cpic.ToFront;
      cname.ToFront;
    end;
    
    ///True - если карта козырная
    property Gl: boolean read k write k := value;
    ///Имя карты (Валет,Туз и т.д.)
    property Name: string read cnamet;
    ///Масть карты (Черви,Пики и т.д.)
    property Mast: string read cma;
    ///Видимость карты
    property Visible: boolean read vis write begin OList.ForEach(i -> begin i.Visible := value end); vis := value end;
    ///Индекс Имени в массиве
    property Index: integer read CProp.Name.IndexOf(cnamet);
    ///Видимость карты
    property CVisible: boolean read cvis write begin Visible := value; rec.Visible := value; cvis := value end;
  end;
  
  Player = class
  private
    px, py, pcx: real;
    pname: string;
    ncard: byte;
    t: TextWPF;
    you: boolean;
    CList := new List<Card>;
  
  public
    constructor(x, y: real; name: string; b: boolean := false);
    begin
      (px, py, pname, pcx, you) := (x, y, name, x, b);
      t := new TextWPF(x + 175, y - 25, name, Colors.Yellow);
    end;
    
    procedure CAdd(c: Card);
    begin
      c.Click += ()->begin
        C.CVisible := false;
        CList.Remove(c);
        CardCount -= 1;
                ncard.ToString.Println;
      end;
      CList.Add(c);
      CardCount += 1;
    end;
    
    property Name: string read pname;
    property CurrenCardX: real read pcx write pcx := value;
    property Left: real read px;
    property Top: real read py;
    property Pyou: boolean read you;
    property CardCount: byte read ncard write ncard := value;
  end;
  
  Coloda = class
  private
    x, y: real;
    TColoda := new List<Card>;
    MCount := 36;
    Koz := CProp.Mast[Random(3)];
    nx := 0;
    CardC: Card;
    NText: TextWPF;
  
  //TColoda.Shuffle - Перемешивает случайным образом
  
  public
    constructor(x, y: real);
    begin
      NText := new TextWPF(30, y + 100, MCount.ToString, Colors.Aqua);
      (Self.x, Self.y) := (x, y);
      for var i := 0 to CProp.Mast.Length - 1 do
      begin
        var mname := CProp.Mast[i];
        for var j := 0 to CProp.Name.Length - 1 do
        begin
          var c := new Card(x, y, CProp.Name[j], mname);
          c.Click += ()->begin
            //ToDo:
          end;
          if Koz = mname
            then c.Gl := true;           
          TColoda.Add(c);
        end;
      end;
      TColoda := TColoda.Shuffle;
      for var i := 0 to TColoda.Count - 1 do
      begin
        var cc := TColoda[i];
        if cc.Gl 
        then begin
          CardC := cc;
          var c2 := TColoda[0];
          TColoda[0] := cc;
          TColoda[i] := c2;
          cc.AnimeTo(10, -80, 0.3);
          cc.Visible := true;
          break;
        end;
      end;
    end;
    
    procedure ReColoda := TColoda := TColoda.Shuffle;
    
    procedure CToPlayer(var p: Player; n: byte := 1);
    begin
      for var i := 1 to n do
      begin
        var c := TColoda.Last;
        var vx := p.CurrenCardX - self.x;
        var vy := p.Top - self.y;
        c.AnimeTo(vx, vy, 0.2);
        if p.Pyou
          then c.Visible := true;
        c.ToFront;
        p.CAdd(c);
        TColoda.Remove(c);
        p.CurrenCardX += 50;
        MCount -= 1;
        NText.Text := MCount.ToString;
        sleep(150);
      end;
    end;
  
  end;

implementation

begin

end. 