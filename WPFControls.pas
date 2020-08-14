unit WPFControls;

interface

uses WPFObjects, MouseEventsWPF;

type
  ButtonWPF = class(RectangleWPF)
    private clb: boolean;
    public event Click: procedure;
  
  private
    procedure MouseDown(x, y: real; mb: integer);
    begin
      if (ObjectUnderPoint(x, y) = self) and (mb = 1)
      then begin
        self.AnimMoveTo(self.Left + 2, self.Top + 2, 0.1);
        clb := true;
      end;
    end;
    
    procedure MouseUp(x, y: real; mb: integer);
    begin
      if (ObjectUnderPoint(x, y) = self)
        then 
        if Click <> nil
          then Click;
      
      if clb
      then begin
        self.AnimMoveTo(self.Left - 2, self.Top - 2, 0.1);
        clb := false;
      end;
    end;
    
    public constructor Create(x, y, w, h: real; cl: Gcolor; s: string);
    begin
      inherited Create(x, y, w, h, cl);
      self.Text := s;
      OnMouseDown += MouseDown;
      OnMouseUp += MouseUp;
    end;
    
    public constructor Create(x, y, w, h, bw: real; cl: Gcolor; bcl: GColor; s: string);
    begin
      inherited Create(x, y, w, h, cl, bw, bcl);
      self.Text := s;
      OnMouseDown += MouseDown;
      OnMouseUp += MouseUp;
    end;
    
    procedure Dispose;
    begin
      OnMouseDown -= MouseDown;
      OnMouseUp -= MouseUp;
    end;
  
  end;
  
  InputWPF = class
    all := new List<InputWPF>;
    focused: InputWPF := nil;
    area: RectangleWPF;
    
    constructor(area: RectangleWPF);
    begin
      self.area := area;
      all += self;
      
      OnMouseDown += (x, y, mb)->
      if mb = 1 then
      begin
        var o := ObjectUnderPoint(x, y);
        focused := o = nil ? nil : all.Find(f -> f.area = o);
      end;
      OnKeyPress += ch ->
      if focused <> nil then
        if area.Text.Length < 20 then
          focused.area.Text += ch;
      
      OnKeyPress += ch ->
      case ch.Code of
        8:
          begin
            
            var s := area.Text;
            area.Text := s[1: s.Length - 2];
          end;
      end;
    end;
    
    property Text: string read area.Text;
    
    procedure Destroy := area.Destroy;
  end;

implementation

begin

end. 