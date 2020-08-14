uses WPFObjects, WPFControls, GameClasses;

begin
  window.Width := 700;
  window.Height := 550;
  window.Clear(colors.Gray);
  
  var LPlayer := new List<Player>;
  
  var c := new Coloda(5, 200);
  sleep(500);
  
  var p := new Player(200, 425, 'Ильшат', true);
  c.CToPlayer(p, 6);
  
  var p1 := new Player(200, 50, 'Артур', true);
  c.CToPlayer(p1, 6);
  
  LPlayer.AddRange(Seq(p, p1));
  
  var b := new ButtonWPF(550, 275, 100, 20, colors.Green, 'Бито');
  b.Click += ()->begin
    LPlayer.ForEach(i -> begin c.CToPlayer(i, 6 - i.CardCount) end);
  end;
end.